# exercise-list-image-viewer

A small exercise about a paginated image viewer with different approaches.

In this branch will use custom MVI pattern


## Requirements

1. Using pixabay API (https://pixabay.com/api/docs/)
2. A custom approach for MVI
3. Have some modularization based on SPM 
4. Independent navigation code
5. Reusable pagination
6. Adjustable theme, language
7. White-label text (Main target can override any text)
8. Network adjustable pipelines
9. Network recorded and replay
10. No key in code for security (Although the API is for backend only, still exposed to reverse enginner API extraction)

## Package architecture

TODO

## MVI architecture

TODO

## Usage

The current project is in **replay mode** only.  
To work with **live mode**, you need an API key from Pixbay.

1. Add your key to `.secrets.env` with this command:

   ```bash
   echo 'PIXBAY_API_KEY="your_api_key_here"' > ./AppSDK/PixbayNetwork/.secrets.env

2. Switch the mode from .replay to .live in PixbayDI.swift (line 8).


## More to follow

The following code will be fixed
- Fast and furious, so lacking unit tests and integration tests
- Very raw detail view

More functionality to come in a different repository (TBD):
- Resources white-label
- Improved detail UI
- Improved search functionality
- Save your media locally
- Browse saved media offline
- Support for videos and other media type
- Support for different providers
- Share your saved media
