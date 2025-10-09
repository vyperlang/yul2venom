
/// @use-src 0:"test_validation/fixtures/solidity/Math512WithDeps.sol"
object "Lib512MathAccessors_402" {
    code {
        /// @src 0:11937:13247  "library Lib512MathAccessors {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("Lib512MathAccessors_402_deployed"), datasize("Lib512MathAccessors_402_deployed"))

        setimmutable(_1, "library_deploy_address", address())

        return(_1, datasize("Lib512MathAccessors_402_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:11937:13247  "library Lib512MathAccessors {..."
        function constructor_Lib512MathAccessors_402() {

            /// @src 0:11937:13247  "library Lib512MathAccessors {..."

        }
        /// @src 0:11937:13247  "library Lib512MathAccessors {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/Math512WithDeps.sol"
    object "Lib512MathAccessors_402_deployed" {
        code {
            /// @src 0:11937:13247  "library Lib512MathAccessors {..."
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

        data ".metadata" hex"a2646970667358221220f999195a17871c83e556a963966bfa1bf19cb3aaf60aa9a0763854d5d4078f1764736f6c634300081e0033"
    }

}




/// @use-src 0:"test_validation/fixtures/solidity/Math512WithDeps.sol"
object "Lib512MathArithmetic_3528" {
    code {
        /// @src 0:16515:62983  "library Lib512MathArithmetic {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("Lib512MathArithmetic_3528_deployed"), datasize("Lib512MathArithmetic_3528_deployed"))

        setimmutable(_1, "library_deploy_address", address())

        return(_1, datasize("Lib512MathArithmetic_3528_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:16515:62983  "library Lib512MathArithmetic {..."
        function constructor_Lib512MathArithmetic_3528() {

            /// @src 0:16515:62983  "library Lib512MathArithmetic {..."

        }
        /// @src 0:16515:62983  "library Lib512MathArithmetic {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/Math512WithDeps.sol"
    object "Lib512MathArithmetic_3528_deployed" {
        code {
            /// @src 0:16515:62983  "library Lib512MathArithmetic {..."
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

        data ".metadata" hex"a2646970667358221220f2320807418cd73fd5eeb6d740a1ab266c3b0ebb93a0648cbbe5430bf95b135b64736f6c634300081e0033"
    }

}




/// @use-src 0:"test_validation/fixtures/solidity/Math512WithDeps.sol"
object "Lib512MathComparisons_695" {
    code {
        /// @src 0:13296:15878  "library Lib512MathComparisons {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("Lib512MathComparisons_695_deployed"), datasize("Lib512MathComparisons_695_deployed"))

        setimmutable(_1, "library_deploy_address", address())

        return(_1, datasize("Lib512MathComparisons_695_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:13296:15878  "library Lib512MathComparisons {..."
        function constructor_Lib512MathComparisons_695() {

            /// @src 0:13296:15878  "library Lib512MathComparisons {..."

        }
        /// @src 0:13296:15878  "library Lib512MathComparisons {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/Math512WithDeps.sol"
    object "Lib512MathComparisons_695_deployed" {
        code {
            /// @src 0:13296:15878  "library Lib512MathComparisons {..."
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

        data ".metadata" hex"a26469706673582212201198e64b9ff7f15ef4537d6abae53b48a00a30485a1680f652de06e27ac4da5864736f6c634300081e0033"
    }

}




/// @use-src 0:"test_validation/fixtures/solidity/Math512WithDeps.sol"
object "Lib512MathExternal_3820" {
    code {
        /// @src 0:64887:65576  "library Lib512MathExternal {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("Lib512MathExternal_3820_deployed"), datasize("Lib512MathExternal_3820_deployed"))

        setimmutable(_1, "library_deploy_address", address())

        return(_1, datasize("Lib512MathExternal_3820_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:64887:65576  "library Lib512MathExternal {..."
        function constructor_Lib512MathExternal_3820() {

            /// @src 0:64887:65576  "library Lib512MathExternal {..."

        }
        /// @src 0:64887:65576  "library Lib512MathExternal {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/Math512WithDeps.sol"
    object "Lib512MathExternal_3820_deployed" {
        code {
            /// @src 0:64887:65576  "library Lib512MathExternal {..."
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

        data ".metadata" hex"a264697066735822122098e2333fa142e0dd5bd1e951f04d6d2d3758c396217c23787d8446e889e3ddef64736f6c634300081e0033"
    }

}




/// @use-src 0:"test_validation/fixtures/solidity/Math512WithDeps.sol"
object "Lib512MathUserDefinedHelpers_3625" {
    code {
        /// @src 0:63033:63912  "library Lib512MathUserDefinedHelpers {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("Lib512MathUserDefinedHelpers_3625_deployed"), datasize("Lib512MathUserDefinedHelpers_3625_deployed"))

        setimmutable(_1, "library_deploy_address", address())

        return(_1, datasize("Lib512MathUserDefinedHelpers_3625_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:63033:63912  "library Lib512MathUserDefinedHelpers {..."
        function constructor_Lib512MathUserDefinedHelpers_3625() {

            /// @src 0:63033:63912  "library Lib512MathUserDefinedHelpers {..."

        }
        /// @src 0:63033:63912  "library Lib512MathUserDefinedHelpers {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/Math512WithDeps.sol"
    object "Lib512MathUserDefinedHelpers_3625_deployed" {
        code {
            /// @src 0:63033:63912  "library Lib512MathUserDefinedHelpers {..."
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

        data ".metadata" hex"a2646970667358221220df505c959c7b89d7b2d66192a7f64474e3ee04d851769896874ded12c0bd342164736f6c634300081e0033"
    }

}




/// @use-src 0:"test_validation/fixtures/solidity/Math512WithDeps.sol"
object "Math_330" {
    code {
        /// @src 0:4026:5281  "library Math {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("Math_330_deployed"), datasize("Math_330_deployed"))

        setimmutable(_1, "library_deploy_address", address())

        return(_1, datasize("Math_330_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:4026:5281  "library Math {..."
        function constructor_Math_330() {

            /// @src 0:4026:5281  "library Math {..."

        }
        /// @src 0:4026:5281  "library Math {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/Math512WithDeps.sol"
    object "Math_330_deployed" {
        code {
            /// @src 0:4026:5281  "library Math {..."
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

        data ".metadata" hex"a2646970667358221220774f1852cc231e276eb2c0becfa292d2d13e09126be4f235ae4ea5dab2c0a61764736f6c634300081e0033"
    }

}




/// @use-src 0:"test_validation/fixtures/solidity/Math512WithDeps.sol"
object "Math512Harness_4198" {
    code {
        /// @src 0:65678:67912  "contract Math512Harness {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        constructor_Math512Harness_4198()

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("Math512Harness_4198_deployed"), datasize("Math512Harness_4198_deployed"))

        return(_1, datasize("Math512Harness_4198_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:65678:67912  "contract Math512Harness {..."
        function constructor_Math512Harness_4198() {

            /// @src 0:65678:67912  "contract Math512Harness {..."

        }
        /// @src 0:65678:67912  "contract Math512Harness {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/Math512WithDeps.sol"
    object "Math512Harness_4198_deployed" {
        code {
            /// @src 0:65678:67912  "contract Math512Harness {..."
            mstore(64, memoryguard(128))

            if iszero(lt(calldatasize(), 4))
            {
                let selector := shift_right_224_unsigned(calldataload(0))
                switch selector

                case 0x2a435348
                {
                    // roundTripExternal(uint256,uint256)

                    external_fun_roundTripExternal_4197()
                }

                case 0x3348c6e1
                {
                    // addUint512Scalar(uint256,uint256,uint256)

                    external_fun_addUint512Scalar_3996()
                }

                case 0x6eca59d7
                {
                    // compareToScalar(uint256,uint256,uint256)

                    external_fun_compareToScalar_4115()
                }

                case 0xc4a67d6d
                {
                    // mulUint256(uint256,uint256)

                    external_fun_mulUint256_4029()
                }

                case 0xc724c47f
                {
                    // modUint512(uint256,uint256,uint256)

                    external_fun_modUint512_4145()
                }

                case 0xf47648ad
                {
                    // gtUint512(uint256,uint256,uint256,uint256)

                    external_fun_gtUint512_4074()
                }

                case 0xfe070ed8
                {
                    // addUint256(uint256,uint256)

                    external_fun_addUint256_3885()
                }

                case 0xff9fbde5
                {
                    // addUint512(uint256,uint256,uint256,uint256)

                    external_fun_addUint512_3948()
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

            function abi_decode_tuple_t_uint256t_uint256(headStart, dataEnd) -> value0, value1 {
                if slt(sub(dataEnd, headStart), 64) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := 0

                    value0 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
                }

                {

                    let offset := 32

                    value1 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
                }

            }

            function abi_encode_t_uint256_to_t_uint256_fromStack(value, pos) {
                mstore(pos, cleanup_t_uint256(value))
            }

            function abi_encode_tuple_t_uint256_t_uint256__to_t_uint256_t_uint256__fromStack(headStart , value0, value1) -> tail {
                tail := add(headStart, 64)

                abi_encode_t_uint256_to_t_uint256_fromStack(value0,  add(headStart, 0))

                abi_encode_t_uint256_to_t_uint256_fromStack(value1,  add(headStart, 32))

            }

            function external_fun_roundTripExternal_4197() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1 :=  abi_decode_tuple_t_uint256t_uint256(4, calldatasize())
                let ret_0, ret_1 :=  fun_roundTripExternal_4197(param_0, param_1)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256_t_uint256__to_t_uint256_t_uint256__fromStack(memPos , ret_0, ret_1)
                return(memPos, sub(memEnd, memPos))

            }

            function abi_decode_tuple_t_uint256t_uint256t_uint256(headStart, dataEnd) -> value0, value1, value2 {
                if slt(sub(dataEnd, headStart), 96) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := 0

                    value0 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
                }

                {

                    let offset := 32

                    value1 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
                }

                {

                    let offset := 64

                    value2 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
                }

            }

            function external_fun_addUint512Scalar_3996() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1, param_2 :=  abi_decode_tuple_t_uint256t_uint256t_uint256(4, calldatasize())
                let ret_0, ret_1 :=  fun_addUint512Scalar_3996(param_0, param_1, param_2)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256_t_uint256__to_t_uint256_t_uint256__fromStack(memPos , ret_0, ret_1)
                return(memPos, sub(memEnd, memPos))

            }

            function cleanup_t_bool(value) -> cleaned {
                cleaned := iszero(iszero(value))
            }

            function abi_encode_t_bool_to_t_bool_fromStack(value, pos) {
                mstore(pos, cleanup_t_bool(value))
            }

            function abi_encode_tuple_t_bool_t_bool__to_t_bool_t_bool__fromStack(headStart , value0, value1) -> tail {
                tail := add(headStart, 64)

                abi_encode_t_bool_to_t_bool_fromStack(value0,  add(headStart, 0))

                abi_encode_t_bool_to_t_bool_fromStack(value1,  add(headStart, 32))

            }

            function external_fun_compareToScalar_4115() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1, param_2 :=  abi_decode_tuple_t_uint256t_uint256t_uint256(4, calldatasize())
                let ret_0, ret_1 :=  fun_compareToScalar_4115(param_0, param_1, param_2)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_bool_t_bool__to_t_bool_t_bool__fromStack(memPos , ret_0, ret_1)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_mulUint256_4029() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1 :=  abi_decode_tuple_t_uint256t_uint256(4, calldatasize())
                let ret_0, ret_1 :=  fun_mulUint256_4029(param_0, param_1)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256_t_uint256__to_t_uint256_t_uint256__fromStack(memPos , ret_0, ret_1)
                return(memPos, sub(memEnd, memPos))

            }

            function abi_encode_tuple_t_uint256__to_t_uint256__fromStack(headStart , value0) -> tail {
                tail := add(headStart, 32)

                abi_encode_t_uint256_to_t_uint256_fromStack(value0,  add(headStart, 0))

            }

            function external_fun_modUint512_4145() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1, param_2 :=  abi_decode_tuple_t_uint256t_uint256t_uint256(4, calldatasize())
                let ret_0 :=  fun_modUint512_4145(param_0, param_1, param_2)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function abi_decode_tuple_t_uint256t_uint256t_uint256t_uint256(headStart, dataEnd) -> value0, value1, value2, value3 {
                if slt(sub(dataEnd, headStart), 128) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := 0

                    value0 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
                }

                {

                    let offset := 32

                    value1 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
                }

                {

                    let offset := 64

                    value2 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
                }

                {

                    let offset := 96

                    value3 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
                }

            }

            function abi_encode_tuple_t_bool__to_t_bool__fromStack(headStart , value0) -> tail {
                tail := add(headStart, 32)

                abi_encode_t_bool_to_t_bool_fromStack(value0,  add(headStart, 0))

            }

            function external_fun_gtUint512_4074() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1, param_2, param_3 :=  abi_decode_tuple_t_uint256t_uint256t_uint256t_uint256(4, calldatasize())
                let ret_0 :=  fun_gtUint512_4074(param_0, param_1, param_2, param_3)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_bool__to_t_bool__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_addUint256_3885() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1 :=  abi_decode_tuple_t_uint256t_uint256(4, calldatasize())
                let ret_0, ret_1 :=  fun_addUint256_3885(param_0, param_1)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256_t_uint256__to_t_uint256_t_uint256__fromStack(memPos , ret_0, ret_1)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_addUint512_3948() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1, param_2, param_3 :=  abi_decode_tuple_t_uint256t_uint256t_uint256t_uint256(4, calldatasize())
                let ret_0, ret_1 :=  fun_addUint512_3948(param_0, param_1, param_2, param_3)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256_t_uint256__to_t_uint256_t_uint256__fromStack(memPos , ret_0, ret_1)
                return(memPos, sub(memEnd, memPos))

            }

            function revert_error_42b3090547df1d2001c96683413b8cf91c1b902ef5e3cb8d9f6f304cf7446f74() {
                revert(0, 0)
            }

            function zero_value_for_split_t_uint256() -> ret {
                ret := 0
            }

            /// @ast-id 4197
            /// @src 0:67590:67910  "function roundTripExternal(uint256 hiIn, uint256 loIn) external pure returns (uint256 hi, uint256 lo) {..."
            function fun_roundTripExternal_4197(var_hiIn_4147, var_loIn_4149) -> var_hi_4152, var_lo_4154 {
                /// @src 0:67668:67678  "uint256 hi"
                let zero_t_uint256_1 := zero_value_for_split_t_uint256()
                var_hi_4152 := zero_t_uint256_1
                /// @src 0:67680:67690  "uint256 lo"
                let zero_t_uint256_2 := zero_value_for_split_t_uint256()
                var_lo_4154 := zero_t_uint256_2

                /// @src 0:67718:67725  "alloc()"
                let expr_4160 := fun_alloc_340()
                /// @src 0:67702:67725  "uint512 value = alloc()"
                let var_value_4158 := expr_4160
                /// @src 0:67735:67740  "value"
                let _3 := var_value_4158
                let expr_4162 := _3
                /// @src 0:67735:67745  "value.from"
                let expr_4164_self := expr_4162
                /// @src 0:67746:67750  "hiIn"
                let _4 := var_hiIn_4147
                let expr_4165 := _4
                /// @src 0:67752:67756  "loIn"
                let _5 := var_loIn_4149
                let expr_4166 := _5
                /// @src 0:67735:67757  "value.from(hiIn, loIn)"
                let expr_4167 := fun_from_375(expr_4164_self, expr_4165, expr_4166)
                /// @src 0:67797:67802  "value"
                let _6 := var_value_4158
                let expr_4172 := _6
                /// @src 0:67797:67813  "value.toExternal"
                let expr_4173_self := expr_4172
                /// @src 0:67797:67815  "value.toExternal()"
                let expr_4174_mpos := fun_toExternal_3819(expr_4173_self)
                /// @src 0:67767:67815  "uint512_external memory ext = value.toExternal()"
                let var_ext_4171_mpos := expr_4174_mpos
                /// @src 0:67840:67847  "alloc()"
                let expr_4180 := fun_alloc_340()
                /// @src 0:67825:67847  "uint512 back = alloc()"
                let var_back_4178 := expr_4180
                /// @src 0:67857:67861  "back"
                let _7 := var_back_4178
                let expr_4182 := _7
                /// @src 0:67857:67866  "back.from"
                let expr_4184_self := expr_4182
                /// @src 0:67867:67870  "ext"
                let _8_mpos := var_ext_4171_mpos
                let expr_4185_mpos := _8_mpos
                /// @src 0:67857:67871  "back.from(ext)"
                let expr_4186 := fun_from_3797(expr_4184_self, expr_4185_mpos)
                /// @src 0:67892:67896  "back"
                let _9 := var_back_4178
                let expr_4191 := _9
                /// @src 0:67892:67901  "back.into"
                let expr_4192_self := expr_4191
                /// @src 0:67892:67903  "back.into()"
                let expr_4193_component_1, expr_4193_component_2 := fun_into_401(expr_4192_self)
                /// @src 0:67881:67903  "(hi, lo) = back.into()"
                var_lo_4154 := expr_4193_component_2
                var_hi_4152 := expr_4193_component_1

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            /// @ast-id 3996
            /// @src 0:66344:66625  "function addUint512Scalar(uint256 hiIn, uint256 loIn, uint256 scalar) external pure returns (uint256 hi, uint256 lo) {..."
            function fun_addUint512Scalar_3996(var_hiIn_3950, var_loIn_3952, var_scalar_3954) -> var_hi_3957, var_lo_3959 {
                /// @src 0:66437:66447  "uint256 hi"
                let zero_t_uint256_10 := zero_value_for_split_t_uint256()
                var_hi_3957 := zero_t_uint256_10
                /// @src 0:66449:66459  "uint256 lo"
                let zero_t_uint256_11 := zero_value_for_split_t_uint256()
                var_lo_3959 := zero_t_uint256_11

                /// @src 0:66486:66493  "alloc()"
                let expr_3965 := fun_alloc_340()
                /// @src 0:66471:66493  "uint512 base = alloc()"
                let var_base_3963 := expr_3965
                /// @src 0:66517:66524  "alloc()"
                let expr_3971 := fun_alloc_340()
                /// @src 0:66503:66524  "uint512 out = alloc()"
                let var_out_3969 := expr_3971
                /// @src 0:66534:66538  "base"
                let _12 := var_base_3963
                let expr_3973 := _12
                /// @src 0:66534:66543  "base.from"
                let expr_3975_self := expr_3973
                /// @src 0:66544:66548  "hiIn"
                let _13 := var_hiIn_3950
                let expr_3976 := _13
                /// @src 0:66550:66554  "loIn"
                let _14 := var_loIn_3952
                let expr_3977 := _14
                /// @src 0:66534:66555  "base.from(hiIn, loIn)"
                let expr_3978 := fun_from_375(expr_3975_self, expr_3976, expr_3977)
                /// @src 0:66565:66568  "out"
                let _15 := var_out_3969
                let expr_3980 := _15
                /// @src 0:66565:66573  "out.oadd"
                let expr_3982_self := expr_3980
                /// @src 0:66574:66578  "base"
                let _16 := var_base_3963
                let expr_3983 := _16
                /// @src 0:66580:66586  "scalar"
                let _17 := var_scalar_3954
                let expr_3984 := _17
                /// @src 0:66565:66587  "out.oadd(base, scalar)"
                let expr_3985 := fun_oadd_876(expr_3982_self, expr_3983, expr_3984)
                /// @src 0:66608:66611  "out"
                let _18 := var_out_3969
                let expr_3990 := _18
                /// @src 0:66608:66616  "out.into"
                let expr_3991_self := expr_3990
                /// @src 0:66608:66618  "out.into()"
                let expr_3992_component_1, expr_3992_component_2 := fun_into_401(expr_3991_self)
                /// @src 0:66597:66618  "(hi, lo) = out.into()"
                var_lo_3959 := expr_3992_component_2
                var_hi_3957 := expr_3992_component_1

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            function zero_value_for_split_t_bool() -> ret {
                ret := 0
            }

            /// @ast-id 4115
            /// @src 0:67078:67374  "function compareToScalar(uint256 hiIn, uint256 loIn, uint256 scalar)..."
            function fun_compareToScalar_4115(var_hiIn_4076, var_loIn_4078, var_scalar_4080) -> var_isGreater_4083, var_isEqual_4085 {
                /// @src 0:67194:67208  "bool isGreater"
                let zero_t_bool_19 := zero_value_for_split_t_bool()
                var_isGreater_4083 := zero_t_bool_19
                /// @src 0:67210:67222  "bool isEqual"
                let zero_t_bool_20 := zero_value_for_split_t_bool()
                var_isEqual_4085 := zero_t_bool_20

                /// @src 0:67254:67261  "alloc()"
                let expr_4091 := fun_alloc_340()
                /// @src 0:67238:67261  "uint512 value = alloc()"
                let var_value_4089 := expr_4091
                /// @src 0:67271:67276  "value"
                let _21 := var_value_4089
                let expr_4093 := _21
                /// @src 0:67271:67281  "value.from"
                let expr_4095_self := expr_4093
                /// @src 0:67282:67286  "hiIn"
                let _22 := var_hiIn_4076
                let expr_4096 := _22
                /// @src 0:67288:67292  "loIn"
                let _23 := var_loIn_4078
                let expr_4097 := _23
                /// @src 0:67271:67293  "value.from(hiIn, loIn)"
                let expr_4098 := fun_from_375(expr_4095_self, expr_4096, expr_4097)
                /// @src 0:67315:67320  "value"
                let _24 := var_value_4089
                let expr_4101 := _24
                /// @src 0:67315:67323  "value.gt"
                let expr_4102_self := expr_4101
                /// @src 0:67324:67330  "scalar"
                let _25 := var_scalar_4080
                let expr_4103 := _25
                /// @src 0:67315:67331  "value.gt(scalar)"
                let expr_4104 := fun_gt_482(expr_4102_self, expr_4103)
                /// @src 0:67303:67331  "isGreater = value.gt(scalar)"
                var_isGreater_4083 := expr_4104
                let expr_4105 := expr_4104
                /// @src 0:67351:67356  "value"
                let _26 := var_value_4089
                let expr_4108 := _26
                /// @src 0:67351:67359  "value.eq"
                let expr_4109_self := expr_4108
                /// @src 0:67360:67366  "scalar"
                let _27 := var_scalar_4080
                let expr_4110 := _27
                /// @src 0:67351:67367  "value.eq(scalar)"
                let expr_4111 := fun_eq_462(expr_4109_self, expr_4110)
                /// @src 0:67341:67367  "isEqual = value.eq(scalar)"
                var_isEqual_4085 := expr_4111
                let expr_4112 := expr_4111

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            /// @ast-id 4029
            /// @src 0:66631:66813  "function mulUint256(uint256 a, uint256 b) external pure returns (uint256 hi, uint256 lo) {..."
            function fun_mulUint256_4029(var_a_3998, var_b_4000) -> var_hi_4003, var_lo_4005 {
                /// @src 0:66696:66706  "uint256 hi"
                let zero_t_uint256_28 := zero_value_for_split_t_uint256()
                var_hi_4003 := zero_t_uint256_28
                /// @src 0:66708:66718  "uint256 lo"
                let zero_t_uint256_29 := zero_value_for_split_t_uint256()
                var_lo_4005 := zero_t_uint256_29

                /// @src 0:66744:66751  "alloc()"
                let expr_4011 := fun_alloc_340()
                /// @src 0:66730:66751  "uint512 out = alloc()"
                let var_out_4009 := expr_4011
                /// @src 0:66761:66764  "out"
                let _30 := var_out_4009
                let expr_4013 := _30
                /// @src 0:66761:66769  "out.omul"
                let expr_4015_self := expr_4013
                /// @src 0:66770:66771  "a"
                let _31 := var_a_3998
                let expr_4016 := _31
                /// @src 0:66773:66774  "b"
                let _32 := var_b_4000
                let expr_4017 := _32
                /// @src 0:66761:66775  "out.omul(a, b)"
                let expr_4018 := fun_omul_1222(expr_4015_self, expr_4016, expr_4017)
                /// @src 0:66796:66799  "out"
                let _33 := var_out_4009
                let expr_4023 := _33
                /// @src 0:66796:66804  "out.into"
                let expr_4024_self := expr_4023
                /// @src 0:66796:66806  "out.into()"
                let expr_4025_component_1, expr_4025_component_2 := fun_into_401(expr_4024_self)
                /// @src 0:66785:66806  "(hi, lo) = out.into()"
                var_lo_4005 := expr_4025_component_2
                var_hi_4003 := expr_4025_component_1

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            /// @ast-id 4145
            /// @src 0:67380:67584  "function modUint512(uint256 hiIn, uint256 loIn, uint256 modulus) external pure returns (uint256) {..."
            function fun_modUint512_4145(var_hiIn_4117, var_loIn_4119, var_modulus_4121) -> var__4124 {
                /// @src 0:67468:67475  "uint256"
                let zero_t_uint256_34 := zero_value_for_split_t_uint256()
                var__4124 := zero_t_uint256_34

                /// @src 0:67503:67510  "alloc()"
                let expr_4130 := fun_alloc_340()
                /// @src 0:67487:67510  "uint512 value = alloc()"
                let var_value_4128 := expr_4130
                /// @src 0:67520:67525  "value"
                let _35 := var_value_4128
                let expr_4132 := _35
                /// @src 0:67520:67530  "value.from"
                let expr_4134_self := expr_4132
                /// @src 0:67531:67535  "hiIn"
                let _36 := var_hiIn_4117
                let expr_4135 := _36
                /// @src 0:67537:67541  "loIn"
                let _37 := var_loIn_4119
                let expr_4136 := _37
                /// @src 0:67520:67542  "value.from(hiIn, loIn)"
                let expr_4137 := fun_from_375(expr_4134_self, expr_4135, expr_4136)
                /// @src 0:67559:67564  "value"
                let _38 := var_value_4128
                let expr_4139 := _38
                /// @src 0:67559:67568  "value.mod"
                let expr_4140_self := expr_4139
                /// @src 0:67569:67576  "modulus"
                let _39 := var_modulus_4121
                let expr_4141 := _39
                /// @src 0:67559:67577  "value.mod(modulus)"
                let expr_4142 := fun_mod_1411(expr_4140_self, expr_4141)
                /// @src 0:67552:67577  "return value.mod(modulus)"
                var__4124 := expr_4142
                leave

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            /// @ast-id 4074
            /// @src 0:66819:67072  "function gtUint512(uint256 aHi, uint256 aLo, uint256 bHi, uint256 bLo) external pure returns (bool) {..."
            function fun_gtUint512_4074(var_aHi_4031, var_aLo_4033, var_bHi_4035, var_bLo_4037) -> var__4040 {
                /// @src 0:66913:66917  "bool"
                let zero_t_bool_40 := zero_value_for_split_t_bool()
                var__4040 := zero_t_bool_40

                /// @src 0:66943:66950  "alloc()"
                let expr_4046 := fun_alloc_340()
                /// @src 0:66929:66950  "uint512 lhs = alloc()"
                let var_lhs_4044 := expr_4046
                /// @src 0:66974:66981  "alloc()"
                let expr_4052 := fun_alloc_340()
                /// @src 0:66960:66981  "uint512 rhs = alloc()"
                let var_rhs_4050 := expr_4052
                /// @src 0:66991:66994  "lhs"
                let _41 := var_lhs_4044
                let expr_4054 := _41
                /// @src 0:66991:66999  "lhs.from"
                let expr_4056_self := expr_4054
                /// @src 0:67000:67003  "aHi"
                let _42 := var_aHi_4031
                let expr_4057 := _42
                /// @src 0:67005:67008  "aLo"
                let _43 := var_aLo_4033
                let expr_4058 := _43
                /// @src 0:66991:67009  "lhs.from(aHi, aLo)"
                let expr_4059 := fun_from_375(expr_4056_self, expr_4057, expr_4058)
                /// @src 0:67019:67022  "rhs"
                let _44 := var_rhs_4050
                let expr_4061 := _44
                /// @src 0:67019:67027  "rhs.from"
                let expr_4063_self := expr_4061
                /// @src 0:67028:67031  "bHi"
                let _45 := var_bHi_4035
                let expr_4064 := _45
                /// @src 0:67033:67036  "bLo"
                let _46 := var_bLo_4037
                let expr_4065 := _46
                /// @src 0:67019:67037  "rhs.from(bHi, bLo)"
                let expr_4066 := fun_from_375(expr_4063_self, expr_4064, expr_4065)
                /// @src 0:67054:67057  "lhs"
                let _47 := var_lhs_4044
                let expr_4068 := _47
                /// @src 0:67054:67060  "lhs.gt"
                let expr_4069_self := expr_4068
                /// @src 0:67061:67064  "rhs"
                let _48 := var_rhs_4050
                let expr_4070 := _48
                /// @src 0:67054:67065  "lhs.gt(rhs)"
                let expr_4071 := fun_gt_611(expr_4069_self, expr_4070)
                /// @src 0:67047:67065  "return lhs.gt(rhs)"
                var__4040 := expr_4071
                leave

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            /// @ast-id 3885
            /// @src 0:65708:65998  "function addUint256(uint256 a, uint256 b) external pure returns (uint256 hi, uint256 lo) {..."
            function fun_addUint256_3885(var_a_3830, var_b_3832) -> var_hi_3835, var_lo_3837 {
                /// @src 0:65773:65783  "uint256 hi"
                let zero_t_uint256_49 := zero_value_for_split_t_uint256()
                var_hi_3835 := zero_t_uint256_49
                /// @src 0:65785:65795  "uint256 lo"
                let zero_t_uint256_50 := zero_value_for_split_t_uint256()
                var_lo_3837 := zero_t_uint256_50

                /// @src 0:65821:65828  "alloc()"
                let expr_3843 := fun_alloc_340()
                /// @src 0:65807:65828  "uint512 lhs = alloc()"
                let var_lhs_3841 := expr_3843
                /// @src 0:65852:65859  "alloc()"
                let expr_3849 := fun_alloc_340()
                /// @src 0:65838:65859  "uint512 rhs = alloc()"
                let var_rhs_3847 := expr_3849
                /// @src 0:65883:65890  "alloc()"
                let expr_3855 := fun_alloc_340()
                /// @src 0:65869:65890  "uint512 out = alloc()"
                let var_out_3853 := expr_3855
                /// @src 0:65900:65903  "lhs"
                let _51 := var_lhs_3841
                let expr_3857 := _51
                /// @src 0:65900:65908  "lhs.from"
                let expr_3859_self := expr_3857
                /// @src 0:65909:65910  "a"
                let _52 := var_a_3830
                let expr_3860 := _52
                /// @src 0:65900:65911  "lhs.from(a)"
                let expr_3861 := fun_from_360(expr_3859_self, expr_3860)
                /// @src 0:65921:65924  "rhs"
                let _53 := var_rhs_3847
                let expr_3863 := _53
                /// @src 0:65921:65929  "rhs.from"
                let expr_3865_self := expr_3863
                /// @src 0:65930:65931  "b"
                let _54 := var_b_3832
                let expr_3866 := _54
                /// @src 0:65921:65932  "rhs.from(b)"
                let expr_3867 := fun_from_360(expr_3865_self, expr_3866)
                /// @src 0:65942:65945  "out"
                let _55 := var_out_3853
                let expr_3869 := _55
                /// @src 0:65942:65950  "out.oadd"
                let expr_3871_self := expr_3869
                /// @src 0:65951:65954  "lhs"
                let _56 := var_lhs_3841
                let expr_3872 := _56
                /// @src 0:65956:65959  "rhs"
                let _57 := var_rhs_3847
                let expr_3873 := _57
                /// @src 0:65942:65960  "out.oadd(lhs, rhs)"
                let expr_3874 := fun_oadd_960(expr_3871_self, expr_3872, expr_3873)
                /// @src 0:65981:65984  "out"
                let _58 := var_out_3853
                let expr_3879 := _58
                /// @src 0:65981:65989  "out.into"
                let expr_3880_self := expr_3879
                /// @src 0:65981:65991  "out.into()"
                let expr_3881_component_1, expr_3881_component_2 := fun_into_401(expr_3880_self)
                /// @src 0:65970:65991  "(hi, lo) = out.into()"
                var_lo_3837 := expr_3881_component_2
                var_hi_3835 := expr_3881_component_1

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            /// @ast-id 3948
            /// @src 0:66004:66338  "function addUint512(uint256 aHi, uint256 aLo, uint256 bHi, uint256 bLo) external pure returns (uint256 hi, uint256 lo) {..."
            function fun_addUint512_3948(var_aHi_3887, var_aLo_3889, var_bHi_3891, var_bLo_3893) -> var_hi_3896, var_lo_3898 {
                /// @src 0:66099:66109  "uint256 hi"
                let zero_t_uint256_59 := zero_value_for_split_t_uint256()
                var_hi_3896 := zero_t_uint256_59
                /// @src 0:66111:66121  "uint256 lo"
                let zero_t_uint256_60 := zero_value_for_split_t_uint256()
                var_lo_3898 := zero_t_uint256_60

                /// @src 0:66147:66154  "alloc()"
                let expr_3904 := fun_alloc_340()
                /// @src 0:66133:66154  "uint512 lhs = alloc()"
                let var_lhs_3902 := expr_3904
                /// @src 0:66178:66185  "alloc()"
                let expr_3910 := fun_alloc_340()
                /// @src 0:66164:66185  "uint512 rhs = alloc()"
                let var_rhs_3908 := expr_3910
                /// @src 0:66209:66216  "alloc()"
                let expr_3916 := fun_alloc_340()
                /// @src 0:66195:66216  "uint512 out = alloc()"
                let var_out_3914 := expr_3916
                /// @src 0:66226:66229  "lhs"
                let _61 := var_lhs_3902
                let expr_3918 := _61
                /// @src 0:66226:66234  "lhs.from"
                let expr_3920_self := expr_3918
                /// @src 0:66235:66238  "aHi"
                let _62 := var_aHi_3887
                let expr_3921 := _62
                /// @src 0:66240:66243  "aLo"
                let _63 := var_aLo_3889
                let expr_3922 := _63
                /// @src 0:66226:66244  "lhs.from(aHi, aLo)"
                let expr_3923 := fun_from_375(expr_3920_self, expr_3921, expr_3922)
                /// @src 0:66254:66257  "rhs"
                let _64 := var_rhs_3908
                let expr_3925 := _64
                /// @src 0:66254:66262  "rhs.from"
                let expr_3927_self := expr_3925
                /// @src 0:66263:66266  "bHi"
                let _65 := var_bHi_3891
                let expr_3928 := _65
                /// @src 0:66268:66271  "bLo"
                let _66 := var_bLo_3893
                let expr_3929 := _66
                /// @src 0:66254:66272  "rhs.from(bHi, bLo)"
                let expr_3930 := fun_from_375(expr_3927_self, expr_3928, expr_3929)
                /// @src 0:66282:66285  "out"
                let _67 := var_out_3914
                let expr_3932 := _67
                /// @src 0:66282:66290  "out.oadd"
                let expr_3934_self := expr_3932
                /// @src 0:66291:66294  "lhs"
                let _68 := var_lhs_3902
                let expr_3935 := _68
                /// @src 0:66296:66299  "rhs"
                let _69 := var_rhs_3908
                let expr_3936 := _69
                /// @src 0:66282:66300  "out.oadd(lhs, rhs)"
                let expr_3937 := fun_oadd_960(expr_3934_self, expr_3935, expr_3936)
                /// @src 0:66321:66324  "out"
                let _70 := var_out_3914
                let expr_3942 := _70
                /// @src 0:66321:66329  "out.into"
                let expr_3943_self := expr_3942
                /// @src 0:66321:66331  "out.into()"
                let expr_3944_component_1, expr_3944_component_2 := fun_into_401(expr_3943_self)
                /// @src 0:66310:66331  "(hi, lo) = out.into()"
                var_lo_3898 := expr_3944_component_2
                var_hi_3896 := expr_3944_component_1

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            function zero_value_for_split_t_userDefinedValueType$_uint512_$332() -> ret {
                ret := 0
            }

            /// @ast-id 340
            /// @src 0:11749:11891  "function alloc() pure returns (uint512 r) {..."
            function fun_alloc_340() -> var_r_336 {
                /// @src 0:11780:11789  "uint512 r"
                let zero_t_userDefinedValueType$_uint512_$332_71 := zero_value_for_split_t_userDefinedValueType$_uint512_$332()
                var_r_336 := zero_t_userDefinedValueType$_uint512_$332_71

                /// @src 0:11797:11889  "assembly (\"memory-safe\") {..."
                {
                    var_r_336 := mload(0x40)
                    mstore(0x40, add(0x40, var_r_336))
                }

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            /// @ast-id 375
            /// @src 0:12190:12423  "function from(uint512 r, uint256 x_hi, uint256 x_lo) internal pure returns (uint512 r_out) {..."
            function fun_from_375(var_r_363, var_x_hi_365, var_x_lo_367) -> var_r_out_371 {
                /// @src 0:12266:12279  "uint512 r_out"
                let zero_t_userDefinedValueType$_uint512_$332_72 := zero_value_for_split_t_userDefinedValueType$_uint512_$332()
                var_r_out_371 := zero_t_userDefinedValueType$_uint512_$332_72

                /// @src 0:12291:12417  "assembly (\"memory-safe\") {..."
                {
                    mstore(var_r_363, var_x_hi_365)
                    mstore(add(0x20, var_r_363), var_x_lo_367)
                    var_r_out_371 := var_r_363
                }

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

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

            function allocate_memory(size) -> memPtr {
                memPtr := allocate_unbounded()
                finalize_allocation(memPtr, size)
            }

            function allocate_memory_struct_t_struct$_uint512_external_$3781_memory_ptr() -> memPtr {
                memPtr := allocate_memory(64)
            }

            function zero_value_for_t_uint256() -> ret {
                ret := 0
            }

            function allocate_and_zero_memory_struct_t_struct$_uint512_external_$3781_memory_ptr() -> memPtr {
                memPtr := allocate_memory_struct_t_struct$_uint512_external_$3781_memory_ptr()
                let offset := memPtr

                mstore(offset, zero_value_for_t_uint256())
                offset := add(offset, 32)

                mstore(offset, zero_value_for_t_uint256())
                offset := add(offset, 32)

            }

            function zero_value_for_split_t_struct$_uint512_external_$3781_memory_ptr() -> ret {
                ret := allocate_and_zero_memory_struct_t_struct$_uint512_external_$3781_memory_ptr()
            }

            /// @ast-id 3819
            /// @src 0:65318:65574  "function toExternal(uint512 x) internal pure returns (uint512_external memory r) {..."
            function fun_toExternal_3819(var_x_3811) -> var_r_3815_mpos {
                /// @src 0:65372:65397  "uint512_external memory r"
                let zero_t_struct$_uint512_external_$3781_memory_ptr_73_mpos := zero_value_for_split_t_struct$_uint512_external_$3781_memory_ptr()
                var_r_3815_mpos := zero_t_struct$_uint512_external_$3781_memory_ptr_73_mpos

                /// @src 0:65409:65568  "assembly (\"memory-safe\") {..."
                {
                    if iszero(eq(mload(0x40), add(0x40, var_r_3815_mpos))) { revert(0x00, 0x00) }
                    mstore(0x40, var_r_3815_mpos)
                    var_r_3815_mpos := var_x_3811
                }

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            /// @ast-id 3797
            /// @src 0:64920:65160  "function from(uint512 r, uint512_external memory x) internal pure returns (uint512) {..."
            function fun_from_3797(var_r_3784, var_x_3787_mpos) -> var__3791 {
                /// @src 0:64995:65002  "uint512"
                let zero_t_userDefinedValueType$_uint512_$332_74 := zero_value_for_split_t_userDefinedValueType$_uint512_$332()
                var__3791 := zero_t_userDefinedValueType$_uint512_$332_74

                /// @src 0:65014:65136  "assembly (\"memory-safe\") {..."
                {
                    mstore(var_r_3784, mload(var_x_3787_mpos))
                    mstore(add(0x20, var_r_3784), mload(add(0x20, var_x_3787_mpos)))
                }
                /// @src 0:65152:65153  "r"
                let _75 := var_r_3784
                let expr_3794 := _75
                /// @src 0:65145:65153  "return r"
                var__3791 := expr_3794
                leave

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            /// @ast-id 401
            /// @src 0:13048:13245  "function into(uint512 x) internal pure returns (uint256 r_hi, uint256 r_lo) {..."
            function fun_into_401(var_x_392) -> var_r_hi_395, var_r_lo_397 {
                /// @src 0:13096:13108  "uint256 r_hi"
                let zero_t_uint256_76 := zero_value_for_split_t_uint256()
                var_r_hi_395 := zero_t_uint256_76
                /// @src 0:13110:13122  "uint256 r_lo"
                let zero_t_uint256_77 := zero_value_for_split_t_uint256()
                var_r_lo_397 := zero_t_uint256_77

                /// @src 0:13134:13239  "assembly (\"memory-safe\") {..."
                {
                    var_r_hi_395 := mload(var_x_392)
                    var_r_lo_397 := mload(add(0x20, var_x_392))
                }

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            /// @ast-id 876
            /// @src 0:17010:17481  "function oadd(uint512 r, uint512 x, uint256 y) internal pure returns (uint512) {..."
            function fun_oadd_876(var_r_843, var_x_846, var_y_848) -> var__852 {
                /// @src 0:17080:17087  "uint512"
                let zero_t_userDefinedValueType$_uint512_$332_78 := zero_value_for_split_t_userDefinedValueType$_uint512_$332()
                var__852 := zero_t_userDefinedValueType$_uint512_$332_78

                /// @src 0:17130:17131  "x"
                let _79 := var_x_846
                let expr_858 := _79
                /// @src 0:17130:17136  "x.into"
                let expr_859_self := expr_858
                /// @src 0:17130:17138  "x.into()"
                let expr_860_component_1, expr_860_component_2 := fun_into_401(expr_859_self)
                /// @src 0:17099:17138  "(uint256 x_hi, uint256 x_lo) = x.into()"
                let var_x_hi_855 := expr_860_component_1
                let var_x_lo_857 := expr_860_component_2
                /// @src 0:17148:17160  "uint256 r_hi"
                let var_r_hi_863
                let zero_t_uint256_80 := zero_value_for_split_t_uint256()
                var_r_hi_863 := zero_t_uint256_80
                /// @src 0:17170:17182  "uint256 r_lo"
                let var_r_lo_866
                let zero_t_uint256_81 := zero_value_for_split_t_uint256()
                var_r_lo_866 := zero_t_uint256_81
                /// @src 0:17192:17440  "assembly (\"memory-safe\") {..."
                {
                    var_r_lo_866 := add(var_x_lo_857, var_y_848)
                    var_r_hi_863 := add(var_x_hi_855, lt(var_r_lo_866, var_x_lo_857))
                }
                /// @src 0:17456:17457  "r"
                let _82 := var_r_843
                let expr_869 := _82
                /// @src 0:17456:17462  "r.from"
                let expr_870_self := expr_869
                /// @src 0:17463:17467  "r_hi"
                let _83 := var_r_hi_863
                let expr_871 := _83
                /// @src 0:17469:17473  "r_lo"
                let _84 := var_r_lo_866
                let expr_872 := _84
                /// @src 0:17456:17474  "r.from(r_hi, r_lo)"
                let expr_873 := fun_from_375(expr_870_self, expr_871, expr_872)
                /// @src 0:17449:17474  "return r.from(r_hi, r_lo)"
                var__852 := expr_873
                leave

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            /// @ast-id 482
            /// @src 0:13967:14182  "function gt(uint512 x, uint256 y) internal pure returns (bool r) {..."
            function fun_gt_482(var_x_465, var_y_467) -> var_r_470 {
                /// @src 0:14024:14030  "bool r"
                let zero_t_bool_85 := zero_value_for_split_t_bool()
                var_r_470 := zero_t_bool_85

                /// @src 0:14073:14074  "x"
                let _86 := var_x_465
                let expr_476 := _86
                /// @src 0:14073:14079  "x.into"
                let expr_477_self := expr_476
                /// @src 0:14073:14081  "x.into()"
                let expr_478_component_1, expr_478_component_2 := fun_into_401(expr_477_self)
                /// @src 0:14042:14081  "(uint256 x_hi, uint256 x_lo) = x.into()"
                let var_x_hi_473 := expr_478_component_1
                let var_x_lo_475 := expr_478_component_2
                /// @src 0:14091:14176  "assembly (\"memory-safe\") {..."
                {
                    var_r_470 := or(gt(var_x_hi_473, 0x00), gt(var_x_lo_475, var_y_467))
                }

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            /// @ast-id 462
            /// @src 0:13747:13961  "function eq(uint512 x, uint256 y) internal pure returns (bool r) {..."
            function fun_eq_462(var_x_445, var_y_447) -> var_r_450 {
                /// @src 0:13804:13810  "bool r"
                let zero_t_bool_87 := zero_value_for_split_t_bool()
                var_r_450 := zero_t_bool_87

                /// @src 0:13853:13854  "x"
                let _88 := var_x_445
                let expr_456 := _88
                /// @src 0:13853:13859  "x.into"
                let expr_457_self := expr_456
                /// @src 0:13853:13861  "x.into()"
                let expr_458_component_1, expr_458_component_2 := fun_into_401(expr_457_self)
                /// @src 0:13822:13861  "(uint256 x_hi, uint256 x_lo) = x.into()"
                let var_x_hi_453 := expr_458_component_1
                let var_x_lo_455 := expr_458_component_2
                /// @src 0:13871:13955  "assembly (\"memory-safe\") {..."
                {
                    var_r_450 := and(iszero(var_x_hi_453), eq(var_x_lo_455, var_y_447))
                }

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            /// @ast-id 1222
            /// @src 0:21054:21226  "function omul(uint512 r, uint256 x, uint256 y) internal pure returns (uint512) {..."
            function fun_omul_1222(var_r_1196, var_x_1198, var_y_1200) -> var__1204 {
                /// @src 0:21124:21131  "uint512"
                let zero_t_userDefinedValueType$_uint512_$332_89 := zero_value_for_split_t_userDefinedValueType$_uint512_$332()
                var__1204 := zero_t_userDefinedValueType$_uint512_$332_89

                /// @src 0:21179:21180  "x"
                let _90 := var_x_1198
                let expr_1211 := _90
                /// @src 0:21182:21183  "y"
                let _91 := var_y_1200
                let expr_1212 := _91
                /// @src 0:21174:21184  "_mul(x, y)"
                let expr_1213_component_1, expr_1213_component_2 := fun__mul_1193(expr_1211, expr_1212)
                /// @src 0:21143:21184  "(uint256 r_hi, uint256 r_lo) = _mul(x, y)"
                let var_r_hi_1207 := expr_1213_component_1
                let var_r_lo_1209 := expr_1213_component_2
                /// @src 0:21201:21202  "r"
                let _92 := var_r_1196
                let expr_1215 := _92
                /// @src 0:21201:21207  "r.from"
                let expr_1216_self := expr_1215
                /// @src 0:21208:21212  "r_hi"
                let _93 := var_r_hi_1207
                let expr_1217 := _93
                /// @src 0:21214:21218  "r_lo"
                let _94 := var_r_lo_1209
                let expr_1218 := _94
                /// @src 0:21201:21219  "r.from(r_hi, r_lo)"
                let expr_1219 := fun_from_375(expr_1216_self, expr_1217, expr_1218)
                /// @src 0:21194:21219  "return r.from(r_hi, r_lo)"
                var__1204 := expr_1219
                leave

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            function cleanup_t_rational_0_by_1(value) -> cleaned {
                cleaned := value
            }

            function identity(value) -> ret {
                ret := value
            }

            function convert_t_rational_0_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_0_by_1(value)))
            }

            function cleanup_t_rational_18_by_1(value) -> cleaned {
                cleaned := value
            }

            function cleanup_t_uint8(value) -> cleaned {
                cleaned := and(value, 0xff)
            }

            function convert_t_rational_18_by_1_to_t_uint8(value) -> converted {
                converted := cleanup_t_uint8(identity(cleanup_t_rational_18_by_1(value)))
            }

            /// @src 0:700:747  "uint8 internal constant DIVISION_BY_ZERO = 0x12"
            function constant_DIVISION_BY_ZERO_20() -> ret {
                /// @src 0:743:747  "0x12"
                let expr_19 := 0x12
                let _97 := convert_t_rational_18_by_1_to_t_uint8(expr_19)

                ret := _97
            }

            function convert_t_uint8_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_uint8(value)))
            }

            /// @ast-id 1411
            /// @src 0:22804:23138  "function mod(uint512 n, uint256 d) internal pure returns (uint256 r) {..."
            function fun_mod_1411(var_n_1382, var_d_1384) -> var_r_1387 {
                /// @src 0:22862:22871  "uint256 r"
                let zero_t_uint256_95 := zero_value_for_split_t_uint256()
                var_r_1387 := zero_t_uint256_95

                /// @src 0:22887:22888  "d"
                let _96 := var_d_1384
                let expr_1389 := _96
                /// @src 0:22892:22893  "0"
                let expr_1390 := 0x00
                /// @src 0:22887:22893  "d == 0"
                let expr_1391 := eq(cleanup_t_uint256(expr_1389), convert_t_rational_0_by_1_to_t_uint256(expr_1390))
                /// @src 0:22883:22955  "if (d == 0) {..."
                if expr_1391 {
                    /// @src 0:22909:22914  "Panic"
                    let expr_1392_address := linkersymbol("test_validation/fixtures/solidity/Math512WithDeps.sol:Panic")
                    /// @src 0:22921:22926  "Panic"
                    let expr_1395_address := linkersymbol("test_validation/fixtures/solidity/Math512WithDeps.sol:Panic")
                    /// @src 0:22921:22943  "Panic.DIVISION_BY_ZERO"
                    let expr_1396 := constant_DIVISION_BY_ZERO_20()
                    /// @src 0:22909:22944  "Panic.panic(Panic.DIVISION_BY_ZERO)"
                    let _98 := convert_t_uint8_to_t_uint256(expr_1396)
                    fun_panic_8(_98)
                    /// @src 0:22883:22955  "if (d == 0) {..."
                }
                /// @src 0:22995:22996  "n"
                let _99 := var_n_1382
                let expr_1405 := _99
                /// @src 0:22995:23001  "n.into"
                let expr_1406_self := expr_1405
                /// @src 0:22995:23003  "n.into()"
                let expr_1407_component_1, expr_1407_component_2 := fun_into_401(expr_1406_self)
                /// @src 0:22964:23003  "(uint256 n_hi, uint256 n_lo) = n.into()"
                let var_n_hi_1402 := expr_1407_component_1
                let var_n_lo_1404 := expr_1407_component_2
                /// @src 0:23013:23132  "assembly (\"memory-safe\") {..."
                {
                    var_r_1387 := mulmod(var_n_hi_1402, sub(0x00, var_d_1384), var_d_1384)
                    var_r_1387 := addmod(var_n_lo_1404, var_r_1387, var_d_1384)
                }

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            /// @ast-id 611
            /// @src 0:14988:15276  "function gt(uint512 x, uint512 y) internal pure returns (bool r) {..."
            function fun_gt_611(var_x_585, var_y_588) -> var_r_591 {
                /// @src 0:15045:15051  "bool r"
                let zero_t_bool_100 := zero_value_for_split_t_bool()
                var_r_591 := zero_t_bool_100

                /// @src 0:15094:15095  "x"
                let _101 := var_x_585
                let expr_597 := _101
                /// @src 0:15094:15100  "x.into"
                let expr_598_self := expr_597
                /// @src 0:15094:15102  "x.into()"
                let expr_599_component_1, expr_599_component_2 := fun_into_401(expr_598_self)
                /// @src 0:15063:15102  "(uint256 x_hi, uint256 x_lo) = x.into()"
                let var_x_hi_594 := expr_599_component_1
                let var_x_lo_596 := expr_599_component_2
                /// @src 0:15143:15144  "y"
                let _102 := var_y_588
                let expr_605 := _102
                /// @src 0:15143:15149  "y.into"
                let expr_606_self := expr_605
                /// @src 0:15143:15151  "y.into()"
                let expr_607_component_1, expr_607_component_2 := fun_into_401(expr_606_self)
                /// @src 0:15112:15151  "(uint256 y_hi, uint256 y_lo) = y.into()"
                let var_y_hi_602 := expr_607_component_1
                let var_y_lo_604 := expr_607_component_2
                /// @src 0:15161:15270  "assembly (\"memory-safe\") {..."
                {
                    var_r_591 := or(gt(var_x_hi_594, var_y_hi_602), and(eq(var_x_hi_594, var_y_hi_602), gt(var_x_lo_596, var_y_lo_604)))
                }

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            /// @ast-id 360
            /// @src 0:11971:12184  "function from(uint512 r, uint256 x) internal pure returns (uint512 r_out) {..."
            function fun_from_360(var_r_350, var_x_352) -> var_r_out_356 {
                /// @src 0:12030:12043  "uint512 r_out"
                let zero_t_userDefinedValueType$_uint512_$332_103 := zero_value_for_split_t_userDefinedValueType$_uint512_$332()
                var_r_out_356 := zero_t_userDefinedValueType$_uint512_$332_103

                /// @src 0:12055:12178  "assembly (\"memory-safe\") {..."
                {
                    mstore(var_r_350, 0x00)
                    mstore(add(0x20, var_r_350), var_x_352)
                    var_r_out_356 := var_r_350
                }

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            /// @ast-id 960
            /// @src 0:18031:18319  "function oadd(uint512 r, uint512 x, uint512 y) internal pure returns (uint512) {..."
            function fun_oadd_960(var_r_914, var_x_917, var_y_920) -> var__924 {
                /// @src 0:18101:18108  "uint512"
                let zero_t_userDefinedValueType$_uint512_$332_104 := zero_value_for_split_t_userDefinedValueType$_uint512_$332()
                var__924 := zero_t_userDefinedValueType$_uint512_$332_104

                /// @src 0:18151:18152  "x"
                let _105 := var_x_917
                let expr_930 := _105
                /// @src 0:18151:18157  "x.into"
                let expr_931_self := expr_930
                /// @src 0:18151:18159  "x.into()"
                let expr_932_component_1, expr_932_component_2 := fun_into_401(expr_931_self)
                /// @src 0:18120:18159  "(uint256 x_hi, uint256 x_lo) = x.into()"
                let var_x_hi_927 := expr_932_component_1
                let var_x_lo_929 := expr_932_component_2
                /// @src 0:18200:18201  "y"
                let _106 := var_y_920
                let expr_938 := _106
                /// @src 0:18200:18206  "y.into"
                let expr_939_self := expr_938
                /// @src 0:18200:18208  "y.into()"
                let expr_940_component_1, expr_940_component_2 := fun_into_401(expr_939_self)
                /// @src 0:18169:18208  "(uint256 y_hi, uint256 y_lo) = y.into()"
                let var_y_hi_935 := expr_940_component_1
                let var_y_lo_937 := expr_940_component_2
                /// @src 0:18254:18258  "x_hi"
                let _107 := var_x_hi_927
                let expr_947 := _107
                /// @src 0:18260:18264  "x_lo"
                let _108 := var_x_lo_929
                let expr_948 := _108
                /// @src 0:18266:18270  "y_hi"
                let _109 := var_y_hi_935
                let expr_949 := _109
                /// @src 0:18272:18276  "y_lo"
                let _110 := var_y_lo_937
                let expr_950 := _110
                /// @src 0:18249:18277  "_add(x_hi, x_lo, y_hi, y_lo)"
                let expr_951_component_1, expr_951_component_2 := fun__add_911(expr_947, expr_948, expr_949, expr_950)
                /// @src 0:18218:18277  "(uint256 r_hi, uint256 r_lo) = _add(x_hi, x_lo, y_hi, y_lo)"
                let var_r_hi_943 := expr_951_component_1
                let var_r_lo_945 := expr_951_component_2
                /// @src 0:18294:18295  "r"
                let _111 := var_r_914
                let expr_953 := _111
                /// @src 0:18294:18300  "r.from"
                let expr_954_self := expr_953
                /// @src 0:18301:18305  "r_hi"
                let _112 := var_r_hi_943
                let expr_955 := _112
                /// @src 0:18307:18311  "r_lo"
                let _113 := var_r_lo_945
                let expr_956 := _113
                /// @src 0:18294:18312  "r.from(r_hi, r_lo)"
                let expr_957 := fun_from_375(expr_954_self, expr_955, expr_956)
                /// @src 0:18287:18312  "return r.from(r_hi, r_lo)"
                var__924 := expr_957
                leave

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            /// @ast-id 1193
            /// @src 0:20724:21048  "function _mul(uint256 x, uint256 y) private pure returns (uint256 r_hi, uint256 r_lo) {..."
            function fun__mul_1193(var_x_1182, var_y_1184) -> var_r_hi_1187, var_r_lo_1189 {
                /// @src 0:20782:20794  "uint256 r_hi"
                let zero_t_uint256_114 := zero_value_for_split_t_uint256()
                var_r_hi_1187 := zero_t_uint256_114
                /// @src 0:20796:20808  "uint256 r_lo"
                let zero_t_uint256_115 := zero_value_for_split_t_uint256()
                var_r_lo_1189 := zero_t_uint256_115

                /// @src 0:20820:21042  "assembly (\"memory-safe\") {..."
                {
                    let usr$mm := mulmod(var_x_1182, var_y_1184, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
                    var_r_lo_1189 := mul(var_x_1182, var_y_1184)
                    var_r_hi_1187 := sub(sub(usr$mm, var_r_lo_1189), lt(usr$mm, var_r_lo_1189))
                }

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            /// @ast-id 8
            /// @src 0:209:436  "function panic(uint256 code) internal pure {..."
            function fun_panic_8(var_code_3) {

                /// @src 0:262:430  "assembly (\"memory-safe\") {..."
                {
                    mstore(0x00, 0x4e487b71)
                    mstore(0x20, var_code_3)
                    revert(0x1c, 0x24)
                }

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

            /// @ast-id 911
            /// @src 0:17598:18025  "function _add(uint256 x_hi, uint256 x_lo, uint256 y_hi, uint256 y_lo)..."
            function fun__add_911(var_x_hi_896, var_x_lo_898, var_y_hi_900, var_y_lo_902) -> var_r_hi_905, var_r_lo_907 {
                /// @src 0:17714:17726  "uint256 r_hi"
                let zero_t_uint256_116 := zero_value_for_split_t_uint256()
                var_r_hi_905 := zero_t_uint256_116
                /// @src 0:17728:17740  "uint256 r_lo"
                let zero_t_uint256_117 := zero_value_for_split_t_uint256()
                var_r_lo_907 := zero_t_uint256_117

                /// @src 0:17756:18019  "assembly (\"memory-safe\") {..."
                {
                    var_r_lo_907 := add(var_x_lo_898, var_y_lo_902)
                    var_r_hi_905 := add(add(var_x_hi_896, var_y_hi_900), lt(var_r_lo_907, var_x_lo_898))
                }

            }
            /// @src 0:65678:67912  "contract Math512Harness {..."

        }

        data ".metadata" hex"a26469706673582212204a8bbaa81d54cf27337fb0b78e6393e0f129a25add42638267d86a8c48db027364736f6c634300081e0033"
    }

}




/// @use-src 0:"test_validation/fixtures/solidity/Math512WithDeps.sol"
object "Panic_39" {
    code {
        /// @src 0:189:1070  "library Panic {..."
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

        /// @src 0:189:1070  "library Panic {..."
        function constructor_Panic_39() {

            /// @src 0:189:1070  "library Panic {..."

        }
        /// @src 0:189:1070  "library Panic {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/Math512WithDeps.sol"
    object "Panic_39_deployed" {
        code {
            /// @src 0:189:1070  "library Panic {..."
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

        data ".metadata" hex"a264697066735822122048b205d8969fdc2ec4e657e22af41762634bca7d9b2d855ae9ce5da89526fc7f64736f6c634300081e0033"
    }

}




/// @use-src 0:"test_validation/fixtures/solidity/Math512WithDeps.sol"
object "UnsafeMath_239" {
    code {
        /// @src 0:1072:4024  "library UnsafeMath {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("UnsafeMath_239_deployed"), datasize("UnsafeMath_239_deployed"))

        setimmutable(_1, "library_deploy_address", address())

        return(_1, datasize("UnsafeMath_239_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:1072:4024  "library UnsafeMath {..."
        function constructor_UnsafeMath_239() {

            /// @src 0:1072:4024  "library UnsafeMath {..."

        }
        /// @src 0:1072:4024  "library UnsafeMath {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/Math512WithDeps.sol"
    object "UnsafeMath_239_deployed" {
        code {
            /// @src 0:1072:4024  "library UnsafeMath {..."
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

        data ".metadata" hex"a26469706673582212200f5234d0ae161dc802b7d5f1509069757e6cf706c9a1749ec1340ae47d20cfae64736f6c634300081e0033"
    }

}

