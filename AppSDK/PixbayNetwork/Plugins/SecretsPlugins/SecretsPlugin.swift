import PackagePlugin
import Foundation

@main
struct SecretsPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        guard target is SourceModuleTarget else { return [] }

        // URLs (Swift 6-preferred)
        let workDirURL  = context.pluginWorkDirectoryURL
        let outDirURL   = workDirURL.appendingPathComponent("Generated", isDirectory: true)
        let outFileURL  = outDirURL.appendingPathComponent("Secrets.swift")
        let bashURL     = URL(fileURLWithPath: "/usr/bin/env")

        // IMPORTANT: compute absolute path to the package root
        let packageRootURL = context.package.directoryURL
        let secretsEnvURL  = packageRootURL.appendingPathComponent(".secrets.env")

        // Pass absolute path strings into the script
        let secretsEnvPath = secretsEnvURL.path
        let outDirPath     = outDirURL.path
        let outFilePath    = outFileURL.path

        let script = """
        set -eo pipefail
        mkdir -p "\(outDirPath)"

        # Source project-local .secrets.env from the PACKAGE ROOT (absolute path)
        if [ -f "\(secretsEnvPath)" ]; then
          set -a
          . "\(secretsEnvPath)"
          set +a
        fi

        # Default to empty if still unset
        : "${PIXBAY_API_KEY:=}"

        # Escape as a valid Swift string literal (includes quotes)
        ESCAPED_API_KEY="$(
          /usr/bin/python3 - <<'PY'
        import os, json
        print(json.dumps(os.environ.get("PIXBAY_API_KEY","")))
        PY
        )"

        cat > "\(outFilePath)" <<SWIFT
        // @generated
        public enum Secrets {
          public static let PIXBAY_API_KEY = ${ESCAPED_API_KEY}
        }
        public let PIXBAY_API_KEY: String = Secrets.PIXBAY_API_KEY
        SWIFT

        # Minimal breadcrumb (masked) so you can see it worked
        case "${PIXBAY_API_KEY}" in
          "") echo "[SecretsPlugin] Loaded PIXBAY_API_KEY: (empty)";;
          *)  echo "[SecretsPlugin] Loaded PIXBAY_API_KEY: ****${PIXBAY_API_KEY: -4}";;
        esac
        echo "[SecretsPlugin] Wrote \(outFilePath)"
        """

        return [
            .prebuildCommand(
                displayName: "Generate Secrets.swift from $PIXBAY_API_KEY",
                executable: bashURL,
                arguments: ["bash", "-lc", script],
                environment: [:],
                outputFilesDirectory: outDirURL
            )
        ]
    }
}
