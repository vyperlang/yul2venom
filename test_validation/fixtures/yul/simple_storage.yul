
/// @use-src 0:"test_validation/fixtures/solidity/SimpleStorage.sol"
object "SimpleStorage_75" {
    code {
        /// @src 0:57:775  "contract SimpleStorage {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        let _1 := copy_arguments_for_constructor_17_object_SimpleStorage_75()
        constructor_SimpleStorage_75(_1)

        let _2 := allocate_unbounded()
        codecopy(_2, dataoffset("SimpleStorage_75_deployed"), datasize("SimpleStorage_75_deployed"))

        return(_2, datasize("SimpleStorage_75_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
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

        function allocate_memory(size) -> memPtr {
            memPtr := allocate_unbounded()
            finalize_allocation(memPtr, size)
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

        function copy_arguments_for_constructor_17_object_SimpleStorage_75() -> ret_param_0 {

            let programSize := datasize("SimpleStorage_75")
            let argSize := sub(codesize(), programSize)

            let memoryDataOffset := allocate_memory(argSize)
            codecopy(memoryDataOffset, programSize, argSize)

            ret_param_0 := abi_decode_tuple_t_uint256_fromMemory(memoryDataOffset, add(memoryDataOffset, argSize))
        }

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

        /// @ast-id 17
        /// @src 0:171:248  "constructor(uint256 initialValue) {..."
        function constructor_SimpleStorage_75(var_initialValue_9) {

            /// @src 0:171:248  "constructor(uint256 initialValue) {..."

            /// @src 0:229:241  "initialValue"
            let _3 := var_initialValue_9
            let expr_13 := _3
            /// @src 0:215:241  "storedValue = initialValue"
            update_storage_value_offset_0_t_uint256_to_t_uint256(0x00, expr_13)
            let expr_14 := expr_13

        }
        /// @src 0:57:775  "contract SimpleStorage {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/SimpleStorage.sol"
    object "SimpleStorage_75_deployed" {
        code {
            /// @src 0:57:775  "contract SimpleStorage {..."
            mstore(64, memoryguard(128))

            if iszero(lt(calldatasize(), 4))
            {
                let selector := shift_right_224_unsigned(calldataload(0))
                switch selector

                case 0x2baeceb7
                {
                    // decrement()

                    external_fun_decrement_74()
                }

                case 0x2e64cec1
                {
                    // retrieve()

                    external_fun_retrieve_39()
                }

                case 0x6057361d
                {
                    // store(uint256)

                    external_fun_store_31()
                }

                case 0xd09de08a
                {
                    // increment()

                    external_fun_increment_53()
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

            function abi_decode_tuple_(headStart, dataEnd)   {
                if slt(sub(dataEnd, headStart), 0) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

            }

            function abi_encode_tuple__to__fromStack(headStart ) -> tail {
                tail := add(headStart, 0)

            }

            function external_fun_decrement_74() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                abi_decode_tuple_(4, calldatasize())
                fun_decrement_74()
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple__to__fromStack(memPos  )
                return(memPos, sub(memEnd, memPos))

            }

            function cleanup_t_uint256(value) -> cleaned {
                cleaned := value
            }

            function abi_encode_t_uint256_to_t_uint256_fromStack(value, pos) {
                mstore(pos, cleanup_t_uint256(value))
            }

            function abi_encode_tuple_t_uint256__to_t_uint256__fromStack(headStart , value0) -> tail {
                tail := add(headStart, 32)

                abi_encode_t_uint256_to_t_uint256_fromStack(value0,  add(headStart, 0))

            }

            function external_fun_retrieve_39() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                abi_decode_tuple_(4, calldatasize())
                let ret_0 :=  fun_retrieve_39()
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() {
                revert(0, 0)
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

            function external_fun_store_31() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                fun_store_31(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple__to__fromStack(memPos  )
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_increment_53() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                abi_decode_tuple_(4, calldatasize())
                fun_increment_53()
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple__to__fromStack(memPos  )
                return(memPos, sub(memEnd, memPos))

            }

            function revert_error_42b3090547df1d2001c96683413b8cf91c1b902ef5e3cb8d9f6f304cf7446f74() {
                revert(0, 0)
            }

            function shift_right_0_unsigned(value) -> newValue {
                newValue :=

                shr(0, value)

            }

            function cleanup_from_storage_t_uint256(value) -> cleaned {
                cleaned := value
            }

            function extract_from_storage_value_offset_0_t_uint256(slot_value) -> value {
                value := cleanup_from_storage_t_uint256(shift_right_0_unsigned(slot_value))
            }

            function read_from_storage_split_offset_0_t_uint256(slot) -> value {
                value := extract_from_storage_value_offset_0_t_uint256(sload(slot))

            }

            function cleanup_t_rational_0_by_1(value) -> cleaned {
                cleaned := value
            }

            function identity(value) -> ret {
                ret := value
            }

            function convert_t_rational_0_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_0_by_1(value)))
            }

            function array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, length) -> updated_pos {
                mstore(pos, length)
                updated_pos := add(pos, 0x20)
            }

            function store_literal_in_memory_d1a36f333738d56db25706f3ee0d170f6f047b262c854995a688cb11b3df3828(memPtr) {

                mstore(add(memPtr, 0), "Cannot decrement below zero")

            }

            function abi_encode_t_stringliteral_d1a36f333738d56db25706f3ee0d170f6f047b262c854995a688cb11b3df3828_to_t_string_memory_ptr_fromStack(pos) -> end {
                pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 27)
                store_literal_in_memory_d1a36f333738d56db25706f3ee0d170f6f047b262c854995a688cb11b3df3828(pos)
                end := add(pos, 32)
            }

            function abi_encode_tuple_t_stringliteral_d1a36f333738d56db25706f3ee0d170f6f047b262c854995a688cb11b3df3828__to_t_string_memory_ptr__fromStack(headStart ) -> tail {
                tail := add(headStart, 32)

                mstore(add(headStart, 0), sub(tail, headStart))
                tail := abi_encode_t_stringliteral_d1a36f333738d56db25706f3ee0d170f6f047b262c854995a688cb11b3df3828_to_t_string_memory_ptr_fromStack( tail)

            }

            function require_helper_t_stringliteral_d1a36f333738d56db25706f3ee0d170f6f047b262c854995a688cb11b3df3828(condition ) {
                if iszero(condition)
                {

                    let memPtr := allocate_unbounded()

                    mstore(memPtr, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                    let end := abi_encode_tuple_t_stringliteral_d1a36f333738d56db25706f3ee0d170f6f047b262c854995a688cb11b3df3828__to_t_string_memory_ptr__fromStack(add(memPtr, 4) )
                    revert(memPtr, sub(end, memPtr))
                }
            }

            function cleanup_t_rational_1_by_1(value) -> cleaned {
                cleaned := value
            }

            function convert_t_rational_1_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_1_by_1(value)))
            }

            function panic_error_0x11() {
                mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                mstore(4, 0x11)
                revert(0, 0x24)
            }

            function checked_sub_t_uint256(x, y) -> diff {
                x := cleanup_t_uint256(x)
                y := cleanup_t_uint256(y)
                diff := sub(x, y)

                if gt(diff, x) { panic_error_0x11() }

            }

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

            /// @ast-id 74
            /// @src 0:594:773  "function decrement() public {..."
            function fun_decrement_74() {

                /// @src 0:640:651  "storedValue"
                let _1 := read_from_storage_split_offset_0_t_uint256(0x00)
                let expr_57 := _1
                /// @src 0:654:655  "0"
                let expr_58 := 0x00
                /// @src 0:640:655  "storedValue > 0"
                let expr_59 := gt(cleanup_t_uint256(expr_57), convert_t_rational_0_by_1_to_t_uint256(expr_58))
                /// @src 0:632:687  "require(storedValue > 0, \"Cannot decrement below zero\")"
                require_helper_t_stringliteral_d1a36f333738d56db25706f3ee0d170f6f047b262c854995a688cb11b3df3828(expr_59)
                /// @src 0:711:722  "storedValue"
                let _2 := read_from_storage_split_offset_0_t_uint256(0x00)
                let expr_64 := _2
                /// @src 0:725:726  "1"
                let expr_65 := 0x01
                /// @src 0:711:726  "storedValue - 1"
                let expr_66 := checked_sub_t_uint256(expr_64, convert_t_rational_1_by_1_to_t_uint256(expr_65))

                /// @src 0:697:726  "storedValue = storedValue - 1"
                update_storage_value_offset_0_t_uint256_to_t_uint256(0x00, expr_66)
                let expr_67 := expr_66
                /// @src 0:754:765  "storedValue"
                let _3 := read_from_storage_split_offset_0_t_uint256(0x00)
                let expr_70 := _3
                /// @src 0:741:766  "ValueChanged(storedValue)"
                let _4 := 0x93fe6d397c74fdf1402a8b72e47b68512f0510d7b98a4bc4cbdf6ac7108b3c59
                {
                    let _5 := allocate_unbounded()
                    let _6 := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(_5 , expr_70)
                    log1(_5, sub(_6, _5) , _4)
                }
            }
            /// @src 0:57:775  "contract SimpleStorage {..."

            function zero_value_for_split_t_uint256() -> ret {
                ret := 0
            }

            /// @ast-id 39
            /// @src 0:375:460  "function retrieve() public view returns (uint256) {..."
            function fun_retrieve_39() -> var__34 {
                /// @src 0:416:423  "uint256"
                let zero_t_uint256_7 := zero_value_for_split_t_uint256()
                var__34 := zero_t_uint256_7

                /// @src 0:442:453  "storedValue"
                let _8 := read_from_storage_split_offset_0_t_uint256(0x00)
                let expr_36 := _8
                /// @src 0:435:453  "return storedValue"
                var__34 := expr_36
                leave

            }
            /// @src 0:57:775  "contract SimpleStorage {..."

            /// @ast-id 31
            /// @src 0:258:365  "function store(uint256 value) public {..."
            function fun_store_31(var_value_19) {

                /// @src 0:319:324  "value"
                let _9 := var_value_19
                let expr_23 := _9
                /// @src 0:305:324  "storedValue = value"
                update_storage_value_offset_0_t_uint256_to_t_uint256(0x00, expr_23)
                let expr_24 := expr_23
                /// @src 0:352:357  "value"
                let _10 := var_value_19
                let expr_27 := _10
                /// @src 0:339:358  "ValueChanged(value)"
                let _11 := 0x93fe6d397c74fdf1402a8b72e47b68512f0510d7b98a4bc4cbdf6ac7108b3c59
                {
                    let _12 := allocate_unbounded()
                    let _13 := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(_12 , expr_27)
                    log1(_12, sub(_13, _12) , _11)
                }
            }
            /// @src 0:57:775  "contract SimpleStorage {..."

            function checked_add_t_uint256(x, y) -> sum {
                x := cleanup_t_uint256(x)
                y := cleanup_t_uint256(y)
                sum := add(x, y)

                if gt(x, sum) { panic_error_0x11() }

            }

            /// @ast-id 53
            /// @src 0:470:584  "function increment() public {..."
            function fun_increment_53() {

                /// @src 0:522:533  "storedValue"
                let _14 := read_from_storage_split_offset_0_t_uint256(0x00)
                let expr_43 := _14
                /// @src 0:536:537  "1"
                let expr_44 := 0x01
                /// @src 0:522:537  "storedValue + 1"
                let expr_45 := checked_add_t_uint256(expr_43, convert_t_rational_1_by_1_to_t_uint256(expr_44))

                /// @src 0:508:537  "storedValue = storedValue + 1"
                update_storage_value_offset_0_t_uint256_to_t_uint256(0x00, expr_45)
                let expr_46 := expr_45
                /// @src 0:565:576  "storedValue"
                let _15 := read_from_storage_split_offset_0_t_uint256(0x00)
                let expr_49 := _15
                /// @src 0:552:577  "ValueChanged(storedValue)"
                let _16 := 0x93fe6d397c74fdf1402a8b72e47b68512f0510d7b98a4bc4cbdf6ac7108b3c59
                {
                    let _17 := allocate_unbounded()
                    let _18 := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(_17 , expr_49)
                    log1(_17, sub(_18, _17) , _16)
                }
            }
            /// @src 0:57:775  "contract SimpleStorage {..."

        }

        data ".metadata" hex"a2646970667358221220a9787642ecb4e2ad84a0850b437b8126fe019c999590a30993cd5d9c899f1e0d64736f6c634300081e0033"
    }

}

