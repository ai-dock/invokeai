#!/bin/false

build_cpu_main() {
    build_cpu_install_invokeai
    build_common_run_tests
}

build_cpu_install_invokeai() {
    build_common_install_invokeai
}

build_cpu_main "$@"