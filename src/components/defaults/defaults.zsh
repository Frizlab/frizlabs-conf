CURRENT_TASK_NAME="TODO"
log_task_warning "The defaults component has not been migrated yet."
log_task_from_res "warning"

#- name: "set key repeat"
#  osx_defaults:
#    # The NSGlobalDomain is the default one, but let’s be explicit
#    domain: NSGlobalDomain
#    key: KeyRepeat
#    type: integer
#    value: 2
#
#- name: "set initial key repeat"
#  osx_defaults: {key: InitialKeyRepeat, type: integer, value: 15}
