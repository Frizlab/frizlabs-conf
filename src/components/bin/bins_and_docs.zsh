#- name: "Import to Photos"
#  author: "frizlab"
#  compat: [MacOSX]
#  bin_paths: ["bash/import-to-photos.sh"]
#  share_paths:
#    - dest_folder: "import-to-photos"
#      files: ["docs/import-to-photos.scpt"]

### Import to Photos ###
bin "frizlab" ":Darwin:" "bash/import-to-photos.sh"
doc "frizlab" ":Darwin:" "import-to-photos" "docs/import-to-photos.scpt"
