
/// @use-src 0:"test_validation/fixtures/solidity/BasicMath.sol"
object "BasicMath_50" {
    code {
        /// @src 0:114:546  "contract BasicMath {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        constructor_BasicMath_50()

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("BasicMath_50_deployed"), datasize("BasicMath_50_deployed"))

        return(_1, datasize("BasicMath_50_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:114:546  "contract BasicMath {..."
        function constructor_BasicMath_50() {

            /// @src 0:114:546  "contract BasicMath {..."

        }
        /// @src 0:114:546  "contract BasicMath {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/BasicMath.sol"
    object "BasicMath_50_deployed" {
        code {
            /// @src 0:114:546  "contract BasicMath {..."
            mstore(64, memoryguard(128))

            if iszero(lt(calldatasize(), 4))
            {
                let selector := shift_right_224_unsigned(calldataload(0))
                switch selector

                case 0x165c4a16
                {
                    // multiply(uint256,uint256)

                    external_fun_multiply_49()
                }

                case 0x20965255
                {
                    // getValue()

                    external_fun_getValue_21()
                }

                case 0x3fa4f245
                {
                    // value()

                    external_fun_value_3()
                }

                case 0x55241077
                {
                    // setValue(uint256)

                    external_fun_setValue_13()
                }

                case 0x771602f7
                {
                    // add(uint256,uint256)

                    external_fun_add_35()
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

            function abi_encode_tuple_t_uint256__to_t_uint256__fromStack(headStart , value0) -> tail {
                tail := add(headStart, 32)

                abi_encode_t_uint256_to_t_uint256_fromStack(value0,  add(headStart, 0))

            }

            function external_fun_multiply_49() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1 :=  abi_decode_tuple_t_uint256t_uint256(4, calldatasize())
                let ret_0 :=  fun_multiply_49(param_0, param_1)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function abi_decode_tuple_(headStart, dataEnd)   {
                if slt(sub(dataEnd, headStart), 0) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

            }

            function external_fun_getValue_21() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                abi_decode_tuple_(4, calldatasize())
                let ret_0 :=  fun_getValue_21()
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function shift_right_unsigned_dynamic(bits, value) -> newValue {
                newValue :=

                shr(bits, value)

            }

            function cleanup_from_storage_t_uint256(value) -> cleaned {
                cleaned := value
            }

            function extract_from_storage_value_dynamict_uint256(slot_value, offset) -> value {
                value := cleanup_from_storage_t_uint256(shift_right_unsigned_dynamic(mul(offset, 8), slot_value))
            }

            function read_from_storage_split_dynamic_t_uint256(slot, offset) -> value {
                value := extract_from_storage_value_dynamict_uint256(sload(slot), offset)

            }

            /// @ast-id 3
            /// @src 0:139:159  "uint256 public value"
            function getter_fun_value_3() -> ret {

                let slot := 0
                let offset := 0

                ret := read_from_storage_split_dynamic_t_uint256(slot, offset)

            }
            /// @src 0:114:546  "contract BasicMath {..."

            function external_fun_value_3() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                abi_decode_tuple_(4, calldatasize())
                let ret_0 :=  getter_fun_value_3()
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function abi_decode_tuple_t_uint256(headStart, dataEnd) -> value0 {
                if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := 0

                    value0 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
                }

            }

            function abi_encode_tuple__to__fromStack(headStart ) -> tail {
                tail := add(headStart, 0)

            }

            function external_fun_setValue_13() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                fun_setValue_13(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple__to__fromStack(memPos  )
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_add_35() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1 :=  abi_decode_tuple_t_uint256t_uint256(4, calldatasize())
                let ret_0 :=  fun_add_35(param_0, param_1)
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

            /// @ast-id 49
            /// @src 0:445:544  "function multiply(uint256 a, uint256 b) public pure returns (uint256) {..."
            function fun_multiply_49(var_a_37, var_b_39) -> var__42 {
                /// @src 0:506:513  "uint256"
                let zero_t_uint256_1 := zero_value_for_split_t_uint256()
                var__42 := zero_t_uint256_1

                /// @src 0:532:533  "a"
                let _2 := var_a_37
                let expr_44 := _2
                /// @src 0:536:537  "b"
                let _3 := var_b_39
                let expr_45 := _3
                /// @src 0:532:537  "a * b"
                let expr_46 := checked_mul_t_uint256(expr_44, expr_45)

                /// @src 0:525:537  "return a * b"
                var__42 := expr_46
                leave

            }
            /// @src 0:114:546  "contract BasicMath {..."

            function shift_right_0_unsigned(value) -> newValue {
                newValue :=

                shr(0, value)

            }

            function extract_from_storage_value_offset_0_t_uint256(slot_value) -> value {
                value := cleanup_from_storage_t_uint256(shift_right_0_unsigned(slot_value))
            }

            function read_from_storage_split_offset_0_t_uint256(slot) -> value {
                value := extract_from_storage_value_offset_0_t_uint256(sload(slot))

            }

            /// @ast-id 21
            /// @src 0:252:331  "function getValue() public view returns (uint256) {..."
            function fun_getValue_21() -> var__16 {
                /// @src 0:293:300  "uint256"
                let zero_t_uint256_4 := zero_value_for_split_t_uint256()
                var__16 := zero_t_uint256_4

                /// @src 0:319:324  "value"
                let _5 := read_from_storage_split_offset_0_t_uint256(0x00)
                let expr_18 := _5
                /// @src 0:312:324  "return value"
                var__16 := expr_18
                leave

            }
            /// @src 0:114:546  "contract BasicMath {..."

            function shift_left_0(value) -> newValue {
                newValue :=

                shl(0, value)

            }

            function update_byte_slice_32_shift_0(value, toInsert) -> result {
                let mask := 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
                toInsert := shift_left_0(toInsert)
                value := and(value, not(mask))
                result := or(value, and(toInsert, mask))
            }

            function identity(value) -> ret {
                ret := value
            }

            function convert_t_uint256_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_uint256(value)))
            }

            function prepare_store_t_uint256(value) -> ret {
                ret := value
            }

            function update_storage_value_offset_0_t_uint256_to_t_uint256(slot, value_0) {
                let convertedValue_0 := convert_t_uint256_to_t_uint256(value_0)
                sstore(slot, update_byte_slice_32_shift_0(sload(slot), prepare_store_t_uint256(convertedValue_0)))
            }

            /// @ast-id 13
            /// @src 0:170:242  "function setValue(uint256 _value) public {..."
            function fun_setValue_13(var__value_5) {

                /// @src 0:229:235  "_value"
                let _6 := var__value_5
                let expr_9 := _6
                /// @src 0:221:235  "value = _value"
                update_storage_value_offset_0_t_uint256_to_t_uint256(0x00, expr_9)
                let expr_10 := expr_9

            }
            /// @src 0:114:546  "contract BasicMath {..."

            function checked_add_t_uint256(x, y) -> sum {
                x := cleanup_t_uint256(x)
                y := cleanup_t_uint256(y)
                sum := add(x, y)

                if gt(x, sum) { panic_error_0x11() }

            }

            /// @ast-id 35
            /// @src 0:341:435  "function add(uint256 a, uint256 b) public pure returns (uint256) {..."
            function fun_add_35(var_a_23, var_b_25) -> var__28 {
                /// @src 0:397:404  "uint256"
                let zero_t_uint256_7 := zero_value_for_split_t_uint256()
                var__28 := zero_t_uint256_7

                /// @src 0:423:424  "a"
                let _8 := var_a_23
                let expr_30 := _8
                /// @src 0:427:428  "b"
                let _9 := var_b_25
                let expr_31 := _9
                /// @src 0:423:428  "a + b"
                let expr_32 := checked_add_t_uint256(expr_30, expr_31)

                /// @src 0:416:428  "return a + b"
                var__28 := expr_32
                leave

            }
            /// @src 0:114:546  "contract BasicMath {..."

        }

        data ".metadata" hex"a26469706673582212208bf46895814b75a1eebfe4416cc8a2693985c19870b6ddaf900a7d46dc58af0e64736f6c634300081e0033"
    }

}

