
/// @use-src 0:"test_validation/fixtures/solidity/Panic.sol"
object "Panic_39" {
    code {
        /// @src 0:58:939  "library Panic {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("Panic_39_deployed"), datasize("Panic_39_deployed"))

        setimmutable(_1, "library_deploy_address", address())

        return(_1, datasize("Panic_39_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:58:939  "library Panic {..."
        function constructor_Panic_39() {

            /// @src 0:58:939  "library Panic {..."

        }
        /// @src 0:58:939  "library Panic {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/Panic.sol"
    object "Panic_39_deployed" {
        code {
            /// @src 0:58:939  "library Panic {..."
            mstore(64, memoryguard(128))

            let called_via_delegatecall := iszero(eq(loadimmutable("library_deploy_address"), address()))

            revert_error_42b3090547df1d2001c96683413b8cf91c1b902ef5e3cb8d9f6f304cf7446f74()

            function shift_right_224_unsigned(value) -> newValue {
                newValue :=

                shr(224, value)

            }

            function allocate_unbounded() -> memPtr {
                memPtr := mload(64)
            }

            function revert_error_42b3090547df1d2001c96683413b8cf91c1b902ef5e3cb8d9f6f304cf7446f74() {
                revert(0, 0)
            }

        }

        data ".metadata" hex"a2646970667358221220947c8fe142d95e0d8a501400cd17af11ffadd5388f7b893bad727edd89ea9d4c64736f6c634300081e0033"
    }

}

