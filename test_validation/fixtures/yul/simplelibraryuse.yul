
/// @use-src 0:"test_validation/fixtures/solidity/SimpleLibraryUse.sol"
object "SimpleLibrary_14" {
    code {
        /// @src 0:58:184  "library SimpleLibrary {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("SimpleLibrary_14_deployed"), datasize("SimpleLibrary_14_deployed"))

        setimmutable(_1, "library_deploy_address", address())

        return(_1, datasize("SimpleLibrary_14_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:58:184  "library SimpleLibrary {..."
        function constructor_SimpleLibrary_14() {

            /// @src 0:58:184  "library SimpleLibrary {..."

        }
        /// @src 0:58:184  "library SimpleLibrary {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/SimpleLibraryUse.sol"
    object "SimpleLibrary_14_deployed" {
        code {
            /// @src 0:58:184  "library SimpleLibrary {..."
            mstore(64, memoryguard(128))

            let called_via_delegatecall := iszero(eq(loadimmutable("library_deploy_address"), address()))

            if iszero(lt(calldatasize(), 4))
            {
                let selector := shift_right_224_unsigned(calldataload(0))
                switch selector

                case 0xeee97206
                {
                    // double(uint256)

                    external_fun_double_13()
                }

                default {}
            }

            revert_error_42b3090547df1d2001c96683413b8cf91c1b902ef5e3cb8d9f6f304cf7446f74()

            function shift_right_224_unsigned(value) -> newValue {
                newValue :=

                shr(224, value)

            }

            function allocate_unbounded() -> memPtr {
                memPtr := mload(64)
            }

            function revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() {
                revert(0, 0)
            }

            function revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() {
                revert(0, 0)
            }

            function cleanup_t_uint256(value) -> cleaned {
                cleaned := value
            }

            function validator_revert_t_uint256(value) {
                if iszero(eq(value, cleanup_t_uint256(value))) { revert(0, 0) }
            }

            function abi_decode_t_uint256(offset, end) -> value {
                value := calldataload(offset)
                validator_revert_t_uint256(value)
            }

            function abi_decode_tuple_t_uint256(headStart, dataEnd) -> value0 {
                if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := 0

                    value0 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
                }

            }

            function abi_encode_t_uint256_to_t_uint256_fromStack_library(value, pos) {
                mstore(pos, cleanup_t_uint256(value))
            }

            function abi_encode_tuple_t_uint256__to_t_uint256__fromStack_library(headStart , value0) -> tail {
                tail := add(headStart, 32)

                abi_encode_t_uint256_to_t_uint256_fromStack_library(value0,  add(headStart, 0))

            }

            function external_fun_double_13() {

                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                let ret_0 :=  fun_double_13(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack_library(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function revert_error_42b3090547df1d2001c96683413b8cf91c1b902ef5e3cb8d9f6f304cf7446f74() {
                revert(0, 0)
            }

            function zero_value_for_split_t_uint256() -> ret {
                ret := 0
            }

            function cleanup_t_rational_2_by_1(value) -> cleaned {
                cleaned := value
            }

            function identity(value) -> ret {
                ret := value
            }

            function convert_t_rational_2_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_2_by_1(value)))
            }

            function panic_error_0x11() {
                mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                mstore(4, 0x11)
                revert(0, 0x24)
            }

            function checked_mul_t_uint256(x, y) -> product {
                x := cleanup_t_uint256(x)
                y := cleanup_t_uint256(y)
                let product_raw := mul(x, y)
                product := cleanup_t_uint256(product_raw)

                // overflow, if x != 0 and y != product/x
                if iszero(
                    or(
                        iszero(x),
                        eq(y, div(product, x))
                    )
                ) { panic_error_0x11() }

            }

            /// @ast-id 13
            /// @src 0:86:182  "function double(uint256 value) external pure returns (uint256) {..."
            function fun_double_13(var_value_3) -> var__6 {
                /// @src 0:140:147  "uint256"
                let zero_t_uint256_1 := zero_value_for_split_t_uint256()
                var__6 := zero_t_uint256_1

                /// @src 0:166:171  "value"
                let _2 := var_value_3
                let expr_8 := _2
                /// @src 0:174:175  "2"
                let expr_9 := 0x02
                /// @src 0:166:175  "value * 2"
                let expr_10 := checked_mul_t_uint256(expr_8, convert_t_rational_2_by_1_to_t_uint256(expr_9))

                /// @src 0:159:175  "return value * 2"
                var__6 := expr_10
                leave

            }
            /// @src 0:58:184  "library SimpleLibrary {..."

        }

        data ".metadata" hex"a26469706673582212206989b0e5874115099744a087e29377c06036d0f647ee785e5bdb1a8da7f0583d64736f6c634300081e0033"
    }

}




/// @use-src 0:"test_validation/fixtures/solidity/SimpleLibraryUse.sol"
object "UsesSimpleLibrary_28" {
    code {
        /// @src 0:186:335  "contract UsesSimpleLibrary {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        constructor_UsesSimpleLibrary_28()

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("UsesSimpleLibrary_28_deployed"), datasize("UsesSimpleLibrary_28_deployed"))

        return(_1, datasize("UsesSimpleLibrary_28_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:186:335  "contract UsesSimpleLibrary {..."
        function constructor_UsesSimpleLibrary_28() {

            /// @src 0:186:335  "contract UsesSimpleLibrary {..."

        }
        /// @src 0:186:335  "contract UsesSimpleLibrary {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/SimpleLibraryUse.sol"
    object "UsesSimpleLibrary_28_deployed" {
        code {
            /// @src 0:186:335  "contract UsesSimpleLibrary {..."
            mstore(64, memoryguard(128))

            if iszero(lt(calldatasize(), 4))
            {
                let selector := shift_right_224_unsigned(calldataload(0))
                switch selector

                case 0xeee97206
                {
                    // double(uint256)

                    external_fun_double_27()
                }

                default {}
            }

            revert_error_42b3090547df1d2001c96683413b8cf91c1b902ef5e3cb8d9f6f304cf7446f74()

            function shift_right_224_unsigned(value) -> newValue {
                newValue :=

                shr(224, value)

            }

            function allocate_unbounded() -> memPtr {
                memPtr := mload(64)
            }

            function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
                revert(0, 0)
            }

            function revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() {
                revert(0, 0)
            }

            function revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() {
                revert(0, 0)
            }

            function cleanup_t_uint256(value) -> cleaned {
                cleaned := value
            }

            function validator_revert_t_uint256(value) {
                if iszero(eq(value, cleanup_t_uint256(value))) { revert(0, 0) }
            }

            function abi_decode_t_uint256(offset, end) -> value {
                value := calldataload(offset)
                validator_revert_t_uint256(value)
            }

            function abi_decode_tuple_t_uint256(headStart, dataEnd) -> value0 {
                if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := 0

                    value0 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
                }

            }

            function abi_encode_t_uint256_to_t_uint256_fromStack(value, pos) {
                mstore(pos, cleanup_t_uint256(value))
            }

            function abi_encode_tuple_t_uint256__to_t_uint256__fromStack(headStart , value0) -> tail {
                tail := add(headStart, 32)

                abi_encode_t_uint256_to_t_uint256_fromStack(value0,  add(headStart, 0))

            }

            function external_fun_double_27() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                let ret_0 :=  fun_double_27(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function revert_error_42b3090547df1d2001c96683413b8cf91c1b902ef5e3cb8d9f6f304cf7446f74() {
                revert(0, 0)
            }

            function zero_value_for_split_t_uint256() -> ret {
                ret := 0
            }

            function convert_t_type$_t_contract$_SimpleLibrary_$14_$_to_t_address(value) -> converted {
                converted := value
            }

            function revert_error_0cc013b6b3b6beabea4e3a74a6d380f0df81852ca99887912475e1f66b2a2c20() {
                revert(0, 0)
            }

            function round_up_to_mul_of_32(value) -> result {
                result := and(add(value, 31), not(31))
            }

            function panic_error_0x41() {
                mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                mstore(4, 0x41)
                revert(0, 0x24)
            }

            function finalize_allocation(memPtr, size) {
                let newFreePtr := add(memPtr, round_up_to_mul_of_32(size))
                // protect against overflow
                if or(gt(newFreePtr, 0xffffffffffffffff), lt(newFreePtr, memPtr)) { panic_error_0x41() }
                mstore(64, newFreePtr)
            }

            function shift_left_224(value) -> newValue {
                newValue :=

                shl(224, value)

            }

            function abi_decode_t_uint256_fromMemory(offset, end) -> value {
                value := mload(offset)
                validator_revert_t_uint256(value)
            }

            function abi_decode_tuple_t_uint256_fromMemory(headStart, dataEnd) -> value0 {
                if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := 0

                    value0 := abi_decode_t_uint256_fromMemory(add(headStart, offset), dataEnd)
                }

            }

            function abi_encode_t_uint256_to_t_uint256_fromStack_library(value, pos) {
                mstore(pos, cleanup_t_uint256(value))
            }

            function abi_encode_tuple_t_uint256__to_t_uint256__fromStack_library(headStart , value0) -> tail {
                tail := add(headStart, 32)

                abi_encode_t_uint256_to_t_uint256_fromStack_library(value0,  add(headStart, 0))

            }

            function revert_forward_1() {
                let pos := allocate_unbounded()
                returndatacopy(pos, 0, returndatasize())
                revert(pos, returndatasize())
            }

            /// @ast-id 27
            /// @src 0:219:333  "function double(uint256 value) external pure returns (uint256) {..."
            function fun_double_27(var_value_16) -> var__19 {
                /// @src 0:273:280  "uint256"
                let zero_t_uint256_1 := zero_value_for_split_t_uint256()
                var__19 := zero_t_uint256_1

                /// @src 0:299:312  "SimpleLibrary"
                let expr_21_address := linkersymbol("test_validation/fixtures/solidity/SimpleLibraryUse.sol:SimpleLibrary")
                /// @src 0:299:319  "SimpleLibrary.double"
                let expr_22_address := convert_t_type$_t_contract$_SimpleLibrary_$14_$_to_t_address(expr_21_address)
                let expr_22_functionSelector := 0xeee97206
                /// @src 0:320:325  "value"
                let _2 := var_value_16
                let expr_23 := _2
                /// @src 0:299:326  "SimpleLibrary.double(value)"

                // storage for arguments and returned data
                let _3 := allocate_unbounded()
                mstore(_3, shift_left_224(expr_22_functionSelector))
                let _4 := abi_encode_tuple_t_uint256__to_t_uint256__fromStack_library(add(_3, 4) , expr_23)

                let _5 := delegatecall(gas(), expr_22_address,  _3, sub(_4, _3), _3, 32)

                if iszero(_5) { revert_forward_1() }

                let expr_24
                if _5 {

                    let _6 := 32

                    if gt(_6, returndatasize()) {
                        _6 := returndatasize()
                    }

                    // update freeMemoryPointer according to dynamic return size
                    finalize_allocation(_3, _6)

                    // decode return parameters from external try-call into retVars
                    expr_24 :=  abi_decode_tuple_t_uint256_fromMemory(_3, add(_3, _6))
                }
                /// @src 0:292:326  "return SimpleLibrary.double(value)"
                var__19 := expr_24
                leave

            }
            /// @src 0:186:335  "contract UsesSimpleLibrary {..."

        }

        data ".metadata" hex"a2646970667358221220db28bae1332502e93b31a8d332700b6e1ad65c0127c077d404997e27bba4f22d64736f6c634300081e0033"
    }

}

