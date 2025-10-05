
/// @use-src 0:"test_validation/fixtures/solidity/ControlFlow.sol"
object "ControlFlow_270" {
    code {
        /// @src 0:57:2235  "contract ControlFlow {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        constructor_ControlFlow_270()

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("ControlFlow_270_deployed"), datasize("ControlFlow_270_deployed"))

        return(_1, datasize("ControlFlow_270_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:57:2235  "contract ControlFlow {..."
        function constructor_ControlFlow_270() {

            /// @src 0:57:2235  "contract ControlFlow {..."

        }
        /// @src 0:57:2235  "contract ControlFlow {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/ControlFlow.sol"
    object "ControlFlow_270_deployed" {
        code {
            /// @src 0:57:2235  "contract ControlFlow {..."
            mstore(64, memoryguard(128))

            if iszero(lt(calldatasize(), 4))
            {
                let selector := shift_right_224_unsigned(calldataload(0))
                switch selector

                case 0x148b677f
                {
                    // requireTest(uint256)

                    external_fun_requireTest_245()
                }

                case 0x4e8e90f3
                {
                    // switchCase(uint8)

                    external_fun_switchCase_128()
                }

                case 0x5e383d21
                {
                    // values(uint256)

                    external_fun_values_5()
                }

                case 0x68270326
                {
                    // breakContinueTest(uint256[])

                    external_fun_breakContinueTest_178()
                }

                case 0x7060c23c
                {
                    // nestedLoops(uint256)

                    external_fun_nestedLoops_219()
                }

                case 0x7141fb00
                {
                    // ifElseTest(uint256)

                    external_fun_ifElseTest_30()
                }

                case 0x7c63519e
                {
                    // assertTest(uint256)

                    external_fun_assertTest_269()
                }

                case 0xb77fd46e
                {
                    // forLoopSum(uint256)

                    external_fun_forLoopSum_60()
                }

                case 0xd7d30a0e
                {
                    // whileLoopFactorial(uint256)

                    external_fun_whileLoopFactorial_96()
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

            function external_fun_requireTest_245() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                let ret_0 :=  fun_requireTest_245(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function cleanup_t_uint8(value) -> cleaned {
                cleaned := and(value, 0xff)
            }

            function validator_revert_t_uint8(value) {
                if iszero(eq(value, cleanup_t_uint8(value))) { revert(0, 0) }
            }

            function abi_decode_t_uint8(offset, end) -> value {
                value := calldataload(offset)
                validator_revert_t_uint8(value)
            }

            function abi_decode_tuple_t_uint8(headStart, dataEnd) -> value0 {
                if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := 0

                    value0 := abi_decode_t_uint8(add(headStart, offset), dataEnd)
                }

            }

            function array_length_t_string_memory_ptr(value) -> length {

                length := mload(value)

            }

            function array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, length) -> updated_pos {
                mstore(pos, length)
                updated_pos := add(pos, 0x20)
            }

            function copy_memory_to_memory_with_cleanup(src, dst, length) {

                mcopy(dst, src, length)
                mstore(add(dst, length), 0)

            }

            function round_up_to_mul_of_32(value) -> result {
                result := and(add(value, 31), not(31))
            }

            function abi_encode_t_string_memory_ptr_to_t_string_memory_ptr_fromStack(value, pos) -> end {
                let length := array_length_t_string_memory_ptr(value)
                pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, length)
                copy_memory_to_memory_with_cleanup(add(value, 0x20), pos, length)
                end := add(pos, round_up_to_mul_of_32(length))
            }

            function abi_encode_tuple_t_string_memory_ptr__to_t_string_memory_ptr__fromStack(headStart , value0) -> tail {
                tail := add(headStart, 32)

                mstore(add(headStart, 0), sub(tail, headStart))
                tail := abi_encode_t_string_memory_ptr_to_t_string_memory_ptr_fromStack(value0,  tail)

            }

            function external_fun_switchCase_128() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint8(4, calldatasize())
                let ret_0 :=  fun_switchCase_128(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_string_memory_ptr__to_t_string_memory_ptr__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function identity(value) -> ret {
                ret := value
            }

            function convert_t_uint256_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_uint256(value)))
            }

            function mapping_index_access_t_mapping$_t_uint256_$_t_uint256_$_of_t_uint256(slot , key) -> dataSlot {
                mstore(0, convert_t_uint256_to_t_uint256(key))
                mstore(0x20, slot)
                dataSlot := keccak256(0, 0x40)
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

            /// @ast-id 5
            /// @src 0:84:125  "mapping(uint256 => uint256) public values"
            function getter_fun_values_5(key_0) -> ret {

                let slot := 0
                let offset := 0

                slot := mapping_index_access_t_mapping$_t_uint256_$_t_uint256_$_of_t_uint256(slot, key_0)

                ret := read_from_storage_split_dynamic_t_uint256(slot, offset)

            }
            /// @src 0:57:2235  "contract ControlFlow {..."

            function external_fun_values_5() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                let ret_0 :=  getter_fun_values_5(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function revert_error_1b9f4a0a5773e33b91aa01db23bf8c55fce1411167c872835e7fa00a4f17d46d() {
                revert(0, 0)
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

            function array_allocation_size_t_array$_t_uint256_$dyn_memory_ptr(length) -> size {
                // Make sure we can allocate memory without overflow
                if gt(length, 0xffffffffffffffff) { panic_error_0x41() }

                size := mul(length, 0x20)

                // add length slot
                size := add(size, 0x20)

            }

            function revert_error_81385d8c0b31fffe14be1da910c8bd3a80be4cfa248e04f42ec0faea3132a8ef() {
                revert(0, 0)
            }

            // uint256[]
            function abi_decode_available_length_t_array$_t_uint256_$dyn_memory_ptr(offset, length, end) -> array {
                array := allocate_memory(array_allocation_size_t_array$_t_uint256_$dyn_memory_ptr(length))
                let dst := array

                mstore(array, length)
                dst := add(array, 0x20)

                let srcEnd := add(offset, mul(length, 0x20))
                if gt(srcEnd, end) {
                    revert_error_81385d8c0b31fffe14be1da910c8bd3a80be4cfa248e04f42ec0faea3132a8ef()
                }
                for { let src := offset } lt(src, srcEnd) { src := add(src, 0x20) }
                {

                    let elementPos := src

                    mstore(dst, abi_decode_t_uint256(elementPos, end))
                    dst := add(dst, 0x20)
                }
            }

            // uint256[]
            function abi_decode_t_array$_t_uint256_$dyn_memory_ptr(offset, end) -> array {
                if iszero(slt(add(offset, 0x1f), end)) { revert_error_1b9f4a0a5773e33b91aa01db23bf8c55fce1411167c872835e7fa00a4f17d46d() }
                let length := calldataload(offset)
                array := abi_decode_available_length_t_array$_t_uint256_$dyn_memory_ptr(add(offset, 0x20), length, end)
            }

            function abi_decode_tuple_t_array$_t_uint256_$dyn_memory_ptr(headStart, dataEnd) -> value0 {
                if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := calldataload(add(headStart, 0))
                    if gt(offset, 0xffffffffffffffff) { revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() }

                    value0 := abi_decode_t_array$_t_uint256_$dyn_memory_ptr(add(headStart, offset), dataEnd)
                }

            }

            function external_fun_breakContinueTest_178() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_array$_t_uint256_$dyn_memory_ptr(4, calldatasize())
                let ret_0 :=  fun_breakContinueTest_178(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_nestedLoops_219() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                let ret_0 :=  fun_nestedLoops_219(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_ifElseTest_30() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                let ret_0 :=  fun_ifElseTest_30(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_string_memory_ptr__to_t_string_memory_ptr__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_assertTest_269() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                let ret_0 :=  fun_assertTest_269(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_forLoopSum_60() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                let ret_0 :=  fun_forLoopSum_60(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_whileLoopFactorial_96() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                let ret_0 :=  fun_whileLoopFactorial_96(param_0)
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

            function cleanup_t_rational_0_by_1(value) -> cleaned {
                cleaned := value
            }

            function convert_t_rational_0_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_0_by_1(value)))
            }

            function store_literal_in_memory_6b17df485e9fb24391f0a5f6e971ff9213a414eba780dcd7eaae085293f2e1e6(memPtr) {

                mstore(add(memPtr, 0), "Value must be positive")

            }

            function abi_encode_t_stringliteral_6b17df485e9fb24391f0a5f6e971ff9213a414eba780dcd7eaae085293f2e1e6_to_t_string_memory_ptr_fromStack(pos) -> end {
                pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 22)
                store_literal_in_memory_6b17df485e9fb24391f0a5f6e971ff9213a414eba780dcd7eaae085293f2e1e6(pos)
                end := add(pos, 32)
            }

            function abi_encode_tuple_t_stringliteral_6b17df485e9fb24391f0a5f6e971ff9213a414eba780dcd7eaae085293f2e1e6__to_t_string_memory_ptr__fromStack(headStart ) -> tail {
                tail := add(headStart, 32)

                mstore(add(headStart, 0), sub(tail, headStart))
                tail := abi_encode_t_stringliteral_6b17df485e9fb24391f0a5f6e971ff9213a414eba780dcd7eaae085293f2e1e6_to_t_string_memory_ptr_fromStack( tail)

            }

            function require_helper_t_stringliteral_6b17df485e9fb24391f0a5f6e971ff9213a414eba780dcd7eaae085293f2e1e6(condition ) {
                if iszero(condition)
                {

                    let memPtr := allocate_unbounded()

                    mstore(memPtr, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                    let end := abi_encode_tuple_t_stringliteral_6b17df485e9fb24391f0a5f6e971ff9213a414eba780dcd7eaae085293f2e1e6__to_t_string_memory_ptr__fromStack(add(memPtr, 4) )
                    revert(memPtr, sub(end, memPtr))
                }
            }

            function cleanup_t_rational_1000_by_1(value) -> cleaned {
                cleaned := value
            }

            function convert_t_rational_1000_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_1000_by_1(value)))
            }

            function store_literal_in_memory_638ee03c4c66fed9ea1d73819c1de6c695e3bab934dac4d00052599d5cdfacf6(memPtr) {

                mstore(add(memPtr, 0), "Value too large")

            }

            function abi_encode_t_stringliteral_638ee03c4c66fed9ea1d73819c1de6c695e3bab934dac4d00052599d5cdfacf6_to_t_string_memory_ptr_fromStack(pos) -> end {
                pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 15)
                store_literal_in_memory_638ee03c4c66fed9ea1d73819c1de6c695e3bab934dac4d00052599d5cdfacf6(pos)
                end := add(pos, 32)
            }

            function abi_encode_tuple_t_stringliteral_638ee03c4c66fed9ea1d73819c1de6c695e3bab934dac4d00052599d5cdfacf6__to_t_string_memory_ptr__fromStack(headStart ) -> tail {
                tail := add(headStart, 32)

                mstore(add(headStart, 0), sub(tail, headStart))
                tail := abi_encode_t_stringliteral_638ee03c4c66fed9ea1d73819c1de6c695e3bab934dac4d00052599d5cdfacf6_to_t_string_memory_ptr_fromStack( tail)

            }

            function require_helper_t_stringliteral_638ee03c4c66fed9ea1d73819c1de6c695e3bab934dac4d00052599d5cdfacf6(condition ) {
                if iszero(condition)
                {

                    let memPtr := allocate_unbounded()

                    mstore(memPtr, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                    let end := abi_encode_tuple_t_stringliteral_638ee03c4c66fed9ea1d73819c1de6c695e3bab934dac4d00052599d5cdfacf6__to_t_string_memory_ptr__fromStack(add(memPtr, 4) )
                    revert(memPtr, sub(end, memPtr))
                }
            }

            function cleanup_t_rational_2_by_1(value) -> cleaned {
                cleaned := value
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

            /// @ast-id 245
            /// @src 0:1903:2090  "function requireTest(uint256 x) public pure returns (uint256) {..."
            function fun_requireTest_245(var_x_221) -> var__224 {
                /// @src 0:1956:1963  "uint256"
                let zero_t_uint256_1 := zero_value_for_split_t_uint256()
                var__224 := zero_t_uint256_1

                /// @src 0:1983:1984  "x"
                let _2 := var_x_221
                let expr_227 := _2
                /// @src 0:1987:1988  "0"
                let expr_228 := 0x00
                /// @src 0:1983:1988  "x > 0"
                let expr_229 := gt(cleanup_t_uint256(expr_227), convert_t_rational_0_by_1_to_t_uint256(expr_228))
                /// @src 0:1975:2015  "require(x > 0, \"Value must be positive\")"
                require_helper_t_stringliteral_6b17df485e9fb24391f0a5f6e971ff9213a414eba780dcd7eaae085293f2e1e6(expr_229)
                /// @src 0:2033:2034  "x"
                let _3 := var_x_221
                let expr_234 := _3
                /// @src 0:2037:2041  "1000"
                let expr_235 := 0x03e8
                /// @src 0:2033:2041  "x < 1000"
                let expr_236 := lt(cleanup_t_uint256(expr_234), convert_t_rational_1000_by_1_to_t_uint256(expr_235))
                /// @src 0:2025:2061  "require(x < 1000, \"Value too large\")"
                require_helper_t_stringliteral_638ee03c4c66fed9ea1d73819c1de6c695e3bab934dac4d00052599d5cdfacf6(expr_236)
                /// @src 0:2078:2079  "x"
                let _4 := var_x_221
                let expr_240 := _4
                /// @src 0:2082:2083  "2"
                let expr_241 := 0x02
                /// @src 0:2078:2083  "x * 2"
                let expr_242 := checked_mul_t_uint256(expr_240, convert_t_rational_2_by_1_to_t_uint256(expr_241))

                /// @src 0:2071:2083  "return x * 2"
                var__224 := expr_242
                leave

            }
            /// @src 0:57:2235  "contract ControlFlow {..."

            function zero_value_for_split_t_string_memory_ptr() -> ret {
                ret := 96
            }

            function cleanup_t_rational_1_by_1(value) -> cleaned {
                cleaned := value
            }

            function convert_t_rational_1_by_1_to_t_uint8(value) -> converted {
                converted := cleanup_t_uint8(identity(cleanup_t_rational_1_by_1(value)))
            }

            function convert_t_rational_2_by_1_to_t_uint8(value) -> converted {
                converted := cleanup_t_uint8(identity(cleanup_t_rational_2_by_1(value)))
            }

            function cleanup_t_rational_3_by_1(value) -> cleaned {
                cleaned := value
            }

            function convert_t_rational_3_by_1_to_t_uint8(value) -> converted {
                converted := cleanup_t_uint8(identity(cleanup_t_rational_3_by_1(value)))
            }

            function array_allocation_size_t_string_memory_ptr(length) -> size {
                // Make sure we can allocate memory without overflow
                if gt(length, 0xffffffffffffffff) { panic_error_0x41() }

                size := round_up_to_mul_of_32(length)

                // add length slot
                size := add(size, 0x20)

            }

            function allocate_memory_array_t_string_memory_ptr(length) -> memPtr {
                let allocSize := array_allocation_size_t_string_memory_ptr(length)
                memPtr := allocate_memory(allocSize)

                mstore(memPtr, length)

            }

            function store_literal_in_memory_0195b5ffc6f5325131a34a05b2f526a9de275da6d76fc5adb0eb320fad7aa65d(memPtr) {

                mstore(add(memPtr, 0), "Invalid Option")

            }

            function copy_literal_to_memory_0195b5ffc6f5325131a34a05b2f526a9de275da6d76fc5adb0eb320fad7aa65d() -> memPtr {
                memPtr := allocate_memory_array_t_string_memory_ptr(14)
                store_literal_in_memory_0195b5ffc6f5325131a34a05b2f526a9de275da6d76fc5adb0eb320fad7aa65d(add(memPtr, 32))
            }

            function convert_t_stringliteral_0195b5ffc6f5325131a34a05b2f526a9de275da6d76fc5adb0eb320fad7aa65d_to_t_string_memory_ptr() -> converted {
                converted := copy_literal_to_memory_0195b5ffc6f5325131a34a05b2f526a9de275da6d76fc5adb0eb320fad7aa65d()
            }

            function store_literal_in_memory_a526a9df55d08e4c040274c9ac30865b447b072cded054f4d645bb45ec622033(memPtr) {

                mstore(add(memPtr, 0), "Option Three")

            }

            function copy_literal_to_memory_a526a9df55d08e4c040274c9ac30865b447b072cded054f4d645bb45ec622033() -> memPtr {
                memPtr := allocate_memory_array_t_string_memory_ptr(12)
                store_literal_in_memory_a526a9df55d08e4c040274c9ac30865b447b072cded054f4d645bb45ec622033(add(memPtr, 32))
            }

            function convert_t_stringliteral_a526a9df55d08e4c040274c9ac30865b447b072cded054f4d645bb45ec622033_to_t_string_memory_ptr() -> converted {
                converted := copy_literal_to_memory_a526a9df55d08e4c040274c9ac30865b447b072cded054f4d645bb45ec622033()
            }

            function store_literal_in_memory_f1cc0686348a60e76c02dc469e0b20ddcc1d88569596675b7f2e99b9470ae60c(memPtr) {

                mstore(add(memPtr, 0), "Option Two")

            }

            function copy_literal_to_memory_f1cc0686348a60e76c02dc469e0b20ddcc1d88569596675b7f2e99b9470ae60c() -> memPtr {
                memPtr := allocate_memory_array_t_string_memory_ptr(10)
                store_literal_in_memory_f1cc0686348a60e76c02dc469e0b20ddcc1d88569596675b7f2e99b9470ae60c(add(memPtr, 32))
            }

            function convert_t_stringliteral_f1cc0686348a60e76c02dc469e0b20ddcc1d88569596675b7f2e99b9470ae60c_to_t_string_memory_ptr() -> converted {
                converted := copy_literal_to_memory_f1cc0686348a60e76c02dc469e0b20ddcc1d88569596675b7f2e99b9470ae60c()
            }

            function store_literal_in_memory_eadc37320786f22b6052e09910bee266c3c6128732fa7777d5d7b5e1981faa23(memPtr) {

                mstore(add(memPtr, 0), "Option One")

            }

            function copy_literal_to_memory_eadc37320786f22b6052e09910bee266c3c6128732fa7777d5d7b5e1981faa23() -> memPtr {
                memPtr := allocate_memory_array_t_string_memory_ptr(10)
                store_literal_in_memory_eadc37320786f22b6052e09910bee266c3c6128732fa7777d5d7b5e1981faa23(add(memPtr, 32))
            }

            function convert_t_stringliteral_eadc37320786f22b6052e09910bee266c3c6128732fa7777d5d7b5e1981faa23_to_t_string_memory_ptr() -> converted {
                converted := copy_literal_to_memory_eadc37320786f22b6052e09910bee266c3c6128732fa7777d5d7b5e1981faa23()
            }

            /// @ast-id 128
            /// @src 0:877:1214  "function switchCase(uint8 option) public pure returns (string memory) {..."
            function fun_switchCase_128(var_option_98) -> var__101_mpos {
                /// @src 0:932:945  "string memory"
                let zero_t_string_memory_ptr_5_mpos := zero_value_for_split_t_string_memory_ptr()
                var__101_mpos := zero_t_string_memory_ptr_5_mpos

                /// @src 0:961:967  "option"
                let _6 := var_option_98
                let expr_103 := _6
                /// @src 0:971:972  "1"
                let expr_104 := 0x01
                /// @src 0:961:972  "option == 1"
                let expr_105 := eq(cleanup_t_uint8(expr_103), convert_t_rational_1_by_1_to_t_uint8(expr_104))
                /// @src 0:957:1208  "if (option == 1) {..."
                switch expr_105
                case 0 {
                    /// @src 0:1028:1034  "option"
                    let _7 := var_option_98
                    let expr_109 := _7
                    /// @src 0:1038:1039  "2"
                    let expr_110 := 0x02
                    /// @src 0:1028:1039  "option == 2"
                    let expr_111 := eq(cleanup_t_uint8(expr_109), convert_t_rational_2_by_1_to_t_uint8(expr_110))
                    /// @src 0:1024:1208  "if (option == 2) {..."
                    switch expr_111
                    case 0 {
                        /// @src 0:1095:1101  "option"
                        let _8 := var_option_98
                        let expr_115 := _8
                        /// @src 0:1105:1106  "3"
                        let expr_116 := 0x03
                        /// @src 0:1095:1106  "option == 3"
                        let expr_117 := eq(cleanup_t_uint8(expr_115), convert_t_rational_3_by_1_to_t_uint8(expr_116))
                        /// @src 0:1091:1208  "if (option == 3) {..."
                        switch expr_117
                        case 0 {
                            /// @src 0:1174:1197  "return \"Invalid Option\""
                            var__101_mpos := convert_t_stringliteral_0195b5ffc6f5325131a34a05b2f526a9de275da6d76fc5adb0eb320fad7aa65d_to_t_string_memory_ptr()
                            leave
                            /// @src 0:1091:1208  "if (option == 3) {..."
                        }
                        default {
                            /// @src 0:1122:1143  "return \"Option Three\""
                            var__101_mpos := convert_t_stringliteral_a526a9df55d08e4c040274c9ac30865b447b072cded054f4d645bb45ec622033_to_t_string_memory_ptr()
                            leave
                            /// @src 0:1091:1208  "if (option == 3) {..."
                        }
                        /// @src 0:1024:1208  "if (option == 2) {..."
                    }
                    default {
                        /// @src 0:1055:1074  "return \"Option Two\""
                        var__101_mpos := convert_t_stringliteral_f1cc0686348a60e76c02dc469e0b20ddcc1d88569596675b7f2e99b9470ae60c_to_t_string_memory_ptr()
                        leave
                        /// @src 0:1024:1208  "if (option == 2) {..."
                    }
                    /// @src 0:957:1208  "if (option == 1) {..."
                }
                default {
                    /// @src 0:988:1007  "return \"Option One\""
                    var__101_mpos := convert_t_stringliteral_eadc37320786f22b6052e09910bee266c3c6128732fa7777d5d7b5e1981faa23_to_t_string_memory_ptr()
                    leave
                    /// @src 0:957:1208  "if (option == 1) {..."
                }

            }
            /// @src 0:57:2235  "contract ControlFlow {..."

            function increment_wrapping_t_uint256(value) -> ret {
                ret := cleanup_t_uint256(add(value, 1))
            }

            function array_length_t_array$_t_uint256_$dyn_memory_ptr(value) -> length {

                length := mload(value)

            }

            function panic_error_0x32() {
                mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                mstore(4, 0x32)
                revert(0, 0x24)
            }

            function memory_array_index_access_t_array$_t_uint256_$dyn_memory_ptr(baseRef, index) -> addr {
                if iszero(lt(index, array_length_t_array$_t_uint256_$dyn_memory_ptr(baseRef))) {
                    panic_error_0x32()
                }

                let offset := mul(index, 32)

                offset := add(offset, 32)

                addr := add(baseRef, offset)
            }

            function read_from_memoryt_uint256(ptr) -> returnValue {

                let value := cleanup_t_uint256(mload(ptr))

                returnValue :=

                value

            }

            function cleanup_t_rational_100_by_1(value) -> cleaned {
                cleaned := value
            }

            function convert_t_rational_100_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_100_by_1(value)))
            }

            function checked_add_t_uint256(x, y) -> sum {
                x := cleanup_t_uint256(x)
                y := cleanup_t_uint256(y)
                sum := add(x, y)

                if gt(x, sum) { panic_error_0x11() }

            }

            /// @ast-id 178
            /// @src 0:1224:1628  "function breakContinueTest(uint256[] memory arr) public pure returns (uint256) {..."
            function fun_breakContinueTest_178(var_arr_131_mpos) -> var__134 {
                /// @src 0:1294:1301  "uint256"
                let zero_t_uint256_9 := zero_value_for_split_t_uint256()
                var__134 := zero_t_uint256_9

                /// @src 0:1327:1328  "0"
                let expr_138 := 0x00
                /// @src 0:1313:1328  "uint256 sum = 0"
                let var_sum_137 := convert_t_rational_0_by_1_to_t_uint256(expr_138)
                /// @src 0:1338:1602  "for (uint256 i = 0; i < arr.length; i++) {..."
                for {
                    /// @src 0:1355:1356  "0"
                    let expr_142 := 0x00
                    /// @src 0:1343:1356  "uint256 i = 0"
                    let var_i_141 := convert_t_rational_0_by_1_to_t_uint256(expr_142)
                    } 1 {
                    /// @src 0:1374:1377  "i++"
                    let _11 := var_i_141
                    let _10 := increment_wrapping_t_uint256(_11)
                    var_i_141 := _10
                    let expr_149 := _11
                }
                {
                    /// @src 0:1358:1359  "i"
                    let _12 := var_i_141
                    let expr_144 := _12
                    /// @src 0:1362:1365  "arr"
                    let _13_mpos := var_arr_131_mpos
                    let expr_145_mpos := _13_mpos
                    /// @src 0:1362:1372  "arr.length"
                    let expr_146 := array_length_t_array$_t_uint256_$dyn_memory_ptr(expr_145_mpos)
                    /// @src 0:1358:1372  "i < arr.length"
                    let expr_147 := lt(cleanup_t_uint256(expr_144), cleanup_t_uint256(expr_146))
                    if iszero(expr_147) { break }
                    /// @src 0:1397:1400  "arr"
                    let _14_mpos := var_arr_131_mpos
                    let expr_151_mpos := _14_mpos
                    /// @src 0:1401:1402  "i"
                    let _15 := var_i_141
                    let expr_152 := _15
                    /// @src 0:1397:1403  "arr[i]"
                    let _16 := read_from_memoryt_uint256(memory_array_index_access_t_array$_t_uint256_$dyn_memory_ptr(expr_151_mpos, expr_152))
                    let expr_153 := _16
                    /// @src 0:1407:1408  "0"
                    let expr_154 := 0x00
                    /// @src 0:1397:1408  "arr[i] == 0"
                    let expr_155 := eq(cleanup_t_uint256(expr_153), convert_t_rational_0_by_1_to_t_uint256(expr_154))
                    /// @src 0:1393:1466  "if (arr[i] == 0) {..."
                    if expr_155 {
                        /// @src 0:1428:1436  "continue"
                        continue
                        /// @src 0:1393:1466  "if (arr[i] == 0) {..."
                    }
                    /// @src 0:1483:1486  "arr"
                    let _17_mpos := var_arr_131_mpos
                    let expr_159_mpos := _17_mpos
                    /// @src 0:1487:1488  "i"
                    let _18 := var_i_141
                    let expr_160 := _18
                    /// @src 0:1483:1489  "arr[i]"
                    let _19 := read_from_memoryt_uint256(memory_array_index_access_t_array$_t_uint256_$dyn_memory_ptr(expr_159_mpos, expr_160))
                    let expr_161 := _19
                    /// @src 0:1492:1495  "100"
                    let expr_162 := 0x64
                    /// @src 0:1483:1495  "arr[i] > 100"
                    let expr_163 := gt(cleanup_t_uint256(expr_161), convert_t_rational_100_by_1_to_t_uint256(expr_162))
                    /// @src 0:1479:1565  "if (arr[i] > 100) {..."
                    if expr_163 {
                        /// @src 0:1515:1520  "break"
                        break
                        /// @src 0:1479:1565  "if (arr[i] > 100) {..."
                    }
                    /// @src 0:1585:1588  "arr"
                    let _20_mpos := var_arr_131_mpos
                    let expr_168_mpos := _20_mpos
                    /// @src 0:1589:1590  "i"
                    let _21 := var_i_141
                    let expr_169 := _21
                    /// @src 0:1585:1591  "arr[i]"
                    let _22 := read_from_memoryt_uint256(memory_array_index_access_t_array$_t_uint256_$dyn_memory_ptr(expr_168_mpos, expr_169))
                    let expr_170 := _22
                    /// @src 0:1578:1591  "sum += arr[i]"
                    let _23 := var_sum_137
                    let expr_171 := checked_add_t_uint256(_23, expr_170)

                    var_sum_137 := expr_171
                }
                /// @src 0:1618:1621  "sum"
                let _24 := var_sum_137
                let expr_175 := _24
                /// @src 0:1611:1621  "return sum"
                var__134 := expr_175
                leave

            }
            /// @src 0:57:2235  "contract ControlFlow {..."

            function increment_t_uint256(value) -> ret {
                value := cleanup_t_uint256(value)
                if eq(value, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) { panic_error_0x11() }
                ret := add(value, 1)
            }

            /// @ast-id 219
            /// @src 0:1638:1893  "function nestedLoops(uint256 n) public pure returns (uint256) {..."
            function fun_nestedLoops_219(var_n_180) -> var__183 {
                /// @src 0:1691:1698  "uint256"
                let zero_t_uint256_25 := zero_value_for_split_t_uint256()
                var__183 := zero_t_uint256_25

                /// @src 0:1726:1727  "0"
                let expr_187 := 0x00
                /// @src 0:1710:1727  "uint256 count = 0"
                let var_count_186 := convert_t_rational_0_by_1_to_t_uint256(expr_187)
                /// @src 0:1737:1865  "for (uint256 i = 0; i < n; i++) {..."
                for {
                    /// @src 0:1754:1755  "0"
                    let expr_191 := 0x00
                    /// @src 0:1742:1755  "uint256 i = 0"
                    let var_i_190 := convert_t_rational_0_by_1_to_t_uint256(expr_191)
                    } 1 {
                    /// @src 0:1764:1767  "i++"
                    let _27 := var_i_190
                    let _26 := increment_wrapping_t_uint256(_27)
                    var_i_190 := _26
                    let expr_197 := _27
                }
                {
                    /// @src 0:1757:1758  "i"
                    let _28 := var_i_190
                    let expr_193 := _28
                    /// @src 0:1761:1762  "n"
                    let _29 := var_n_180
                    let expr_194 := _29
                    /// @src 0:1757:1762  "i < n"
                    let expr_195 := lt(cleanup_t_uint256(expr_193), cleanup_t_uint256(expr_194))
                    if iszero(expr_195) { break }
                    /// @src 0:1783:1855  "for (uint256 j = 0; j < n; j++) {..."
                    for {
                        /// @src 0:1800:1801  "0"
                        let expr_201 := 0x00
                        /// @src 0:1788:1801  "uint256 j = 0"
                        let var_j_200 := convert_t_rational_0_by_1_to_t_uint256(expr_201)
                        } 1 {
                        /// @src 0:1810:1813  "j++"
                        let _31 := var_j_200
                        let _30 := increment_wrapping_t_uint256(_31)
                        var_j_200 := _30
                        let expr_207 := _31
                    }
                    {
                        /// @src 0:1803:1804  "j"
                        let _32 := var_j_200
                        let expr_203 := _32
                        /// @src 0:1807:1808  "n"
                        let _33 := var_n_180
                        let expr_204 := _33
                        /// @src 0:1803:1808  "j < n"
                        let expr_205 := lt(cleanup_t_uint256(expr_203), cleanup_t_uint256(expr_204))
                        if iszero(expr_205) { break }
                        /// @src 0:1833:1840  "count++"
                        let _35 := var_count_186
                        let _34 := increment_t_uint256(_35)
                        var_count_186 := _34
                        let expr_210 := _35
                    }
                }
                /// @src 0:1881:1886  "count"
                let _36 := var_count_186
                let expr_216 := _36
                /// @src 0:1874:1886  "return count"
                var__183 := expr_216
                leave

            }
            /// @src 0:57:2235  "contract ControlFlow {..."

            function cleanup_t_rational_10_by_1(value) -> cleaned {
                cleaned := value
            }

            function convert_t_rational_10_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_10_by_1(value)))
            }

            function store_literal_in_memory_f65523197022c456a52566f5d6df7057319191a6932be0d98935db96422bb06c(memPtr) {

                mstore(add(memPtr, 0), "100 or more")

            }

            function copy_literal_to_memory_f65523197022c456a52566f5d6df7057319191a6932be0d98935db96422bb06c() -> memPtr {
                memPtr := allocate_memory_array_t_string_memory_ptr(11)
                store_literal_in_memory_f65523197022c456a52566f5d6df7057319191a6932be0d98935db96422bb06c(add(memPtr, 32))
            }

            function convert_t_stringliteral_f65523197022c456a52566f5d6df7057319191a6932be0d98935db96422bb06c_to_t_string_memory_ptr() -> converted {
                converted := copy_literal_to_memory_f65523197022c456a52566f5d6df7057319191a6932be0d98935db96422bb06c()
            }

            function store_literal_in_memory_ac84df09471167350fc855177181c3d9945d61856e8b9f4a3860fcb33e80c35a(memPtr) {

                mstore(add(memPtr, 0), "less than 100")

            }

            function copy_literal_to_memory_ac84df09471167350fc855177181c3d9945d61856e8b9f4a3860fcb33e80c35a() -> memPtr {
                memPtr := allocate_memory_array_t_string_memory_ptr(13)
                store_literal_in_memory_ac84df09471167350fc855177181c3d9945d61856e8b9f4a3860fcb33e80c35a(add(memPtr, 32))
            }

            function convert_t_stringliteral_ac84df09471167350fc855177181c3d9945d61856e8b9f4a3860fcb33e80c35a_to_t_string_memory_ptr() -> converted {
                converted := copy_literal_to_memory_ac84df09471167350fc855177181c3d9945d61856e8b9f4a3860fcb33e80c35a()
            }

            function store_literal_in_memory_63c4f664a61886c11d30aa424be231dabab30def14e244c55944622455ae7091(memPtr) {

                mstore(add(memPtr, 0), "less than 10")

            }

            function copy_literal_to_memory_63c4f664a61886c11d30aa424be231dabab30def14e244c55944622455ae7091() -> memPtr {
                memPtr := allocate_memory_array_t_string_memory_ptr(12)
                store_literal_in_memory_63c4f664a61886c11d30aa424be231dabab30def14e244c55944622455ae7091(add(memPtr, 32))
            }

            function convert_t_stringliteral_63c4f664a61886c11d30aa424be231dabab30def14e244c55944622455ae7091_to_t_string_memory_ptr() -> converted {
                converted := copy_literal_to_memory_63c4f664a61886c11d30aa424be231dabab30def14e244c55944622455ae7091()
            }

            /// @ast-id 30
            /// @src 0:136:394  "function ifElseTest(uint256 x) public pure returns (string memory) {..."
            function fun_ifElseTest_30(var_x_7) -> var__10_mpos {
                /// @src 0:188:201  "string memory"
                let zero_t_string_memory_ptr_37_mpos := zero_value_for_split_t_string_memory_ptr()
                var__10_mpos := zero_t_string_memory_ptr_37_mpos

                /// @src 0:217:218  "x"
                let _38 := var_x_7
                let expr_12 := _38
                /// @src 0:221:223  "10"
                let expr_13 := 0x0a
                /// @src 0:217:223  "x < 10"
                let expr_14 := lt(cleanup_t_uint256(expr_12), convert_t_rational_10_by_1_to_t_uint256(expr_13))
                /// @src 0:213:388  "if (x < 10) {..."
                switch expr_14
                case 0 {
                    /// @src 0:281:282  "x"
                    let _39 := var_x_7
                    let expr_18 := _39
                    /// @src 0:285:288  "100"
                    let expr_19 := 0x64
                    /// @src 0:281:288  "x < 100"
                    let expr_20 := lt(cleanup_t_uint256(expr_18), convert_t_rational_100_by_1_to_t_uint256(expr_19))
                    /// @src 0:277:388  "if (x < 100) {..."
                    switch expr_20
                    case 0 {
                        /// @src 0:357:377  "return \"100 or more\""
                        var__10_mpos := convert_t_stringliteral_f65523197022c456a52566f5d6df7057319191a6932be0d98935db96422bb06c_to_t_string_memory_ptr()
                        leave
                        /// @src 0:277:388  "if (x < 100) {..."
                    }
                    default {
                        /// @src 0:304:326  "return \"less than 100\""
                        var__10_mpos := convert_t_stringliteral_ac84df09471167350fc855177181c3d9945d61856e8b9f4a3860fcb33e80c35a_to_t_string_memory_ptr()
                        leave
                        /// @src 0:277:388  "if (x < 100) {..."
                    }
                    /// @src 0:213:388  "if (x < 10) {..."
                }
                default {
                    /// @src 0:239:260  "return \"less than 10\""
                    var__10_mpos := convert_t_stringliteral_63c4f664a61886c11d30aa424be231dabab30def14e244c55944622455ae7091_to_t_string_memory_ptr()
                    leave
                    /// @src 0:213:388  "if (x < 10) {..."
                }

            }
            /// @src 0:57:2235  "contract ControlFlow {..."

            function panic_error_0x12() {
                mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                mstore(4, 0x12)
                revert(0, 0x24)
            }

            function checked_div_t_uint256(x, y) -> r {
                x := cleanup_t_uint256(x)
                y := cleanup_t_uint256(y)
                if iszero(y) { panic_error_0x12() }

                r := div(x, y)
            }

            function panic_error_0x01() {
                mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                mstore(4, 0x01)
                revert(0, 0x24)
            }

            function assert_helper(condition) {
                if iszero(condition) { panic_error_0x01() }
            }

            /// @ast-id 269
            /// @src 0:2100:2233  "function assertTest(uint256 x) public pure returns (uint256) {..."
            function fun_assertTest_269(var_x_247) -> var__250 {
                /// @src 0:2152:2159  "uint256"
                let zero_t_uint256_40 := zero_value_for_split_t_uint256()
                var__250 := zero_t_uint256_40

                /// @src 0:2178:2179  "x"
                let _41 := var_x_247
                let expr_253 := _41
                /// @src 0:2182:2199  "type(uint256).max"
                let expr_258 := 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
                /// @src 0:2202:2203  "2"
                let expr_259 := 0x02
                /// @src 0:2182:2203  "type(uint256).max / 2"
                let expr_260 := checked_div_t_uint256(expr_258, convert_t_rational_2_by_1_to_t_uint256(expr_259))

                /// @src 0:2178:2203  "x < type(uint256).max / 2"
                let expr_261 := lt(cleanup_t_uint256(expr_253), cleanup_t_uint256(expr_260))
                /// @src 0:2171:2204  "assert(x < type(uint256).max / 2)"
                assert_helper(expr_261)
                /// @src 0:2221:2222  "x"
                let _42 := var_x_247
                let expr_264 := _42
                /// @src 0:2225:2226  "2"
                let expr_265 := 0x02
                /// @src 0:2221:2226  "x * 2"
                let expr_266 := checked_mul_t_uint256(expr_264, convert_t_rational_2_by_1_to_t_uint256(expr_265))

                /// @src 0:2214:2226  "return x * 2"
                var__250 := expr_266
                leave

            }
            /// @src 0:57:2235  "contract ControlFlow {..."

            function convert_t_rational_1_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_1_by_1(value)))
            }

            /// @ast-id 60
            /// @src 0:404:592  "function forLoopSum(uint256 n) public pure returns (uint256) {..."
            function fun_forLoopSum_60(var_n_32) -> var__35 {
                /// @src 0:456:463  "uint256"
                let zero_t_uint256_43 := zero_value_for_split_t_uint256()
                var__35 := zero_t_uint256_43

                /// @src 0:489:490  "0"
                let expr_39 := 0x00
                /// @src 0:475:490  "uint256 sum = 0"
                let var_sum_38 := convert_t_rational_0_by_1_to_t_uint256(expr_39)
                /// @src 0:500:566  "for (uint256 i = 1; i <= n; i++) {..."
                for {
                    /// @src 0:517:518  "1"
                    let expr_43 := 0x01
                    /// @src 0:505:518  "uint256 i = 1"
                    let var_i_42 := convert_t_rational_1_by_1_to_t_uint256(expr_43)
                    } 1 {
                    /// @src 0:528:531  "i++"
                    let _45 := var_i_42
                    let _44 := increment_t_uint256(_45)
                    var_i_42 := _44
                    let expr_49 := _45
                }
                {
                    /// @src 0:520:521  "i"
                    let _46 := var_i_42
                    let expr_45 := _46
                    /// @src 0:525:526  "n"
                    let _47 := var_n_32
                    let expr_46 := _47
                    /// @src 0:520:526  "i <= n"
                    let expr_47 := iszero(gt(cleanup_t_uint256(expr_45), cleanup_t_uint256(expr_46)))
                    if iszero(expr_47) { break }
                    /// @src 0:554:555  "i"
                    let _48 := var_i_42
                    let expr_52 := _48
                    /// @src 0:547:555  "sum += i"
                    let _49 := var_sum_38
                    let expr_53 := checked_add_t_uint256(_49, expr_52)

                    var_sum_38 := expr_53
                }
                /// @src 0:582:585  "sum"
                let _50 := var_sum_38
                let expr_57 := _50
                /// @src 0:575:585  "return sum"
                var__35 := expr_57
                leave

            }
            /// @src 0:57:2235  "contract ControlFlow {..."

            function decrement_t_uint256(value) -> ret {
                value := cleanup_t_uint256(value)
                if eq(value, 0x00) { panic_error_0x11() }
                ret := sub(value, 1)
            }

            /// @ast-id 96
            /// @src 0:602:867  "function whileLoopFactorial(uint256 n) public pure returns (uint256) {..."
            function fun_whileLoopFactorial_96(var_n_62) -> var__65 {
                /// @src 0:662:669  "uint256"
                let zero_t_uint256_51 := zero_value_for_split_t_uint256()
                var__65 := zero_t_uint256_51

                /// @src 0:685:686  "n"
                let _52 := var_n_62
                let expr_67 := _52
                /// @src 0:690:691  "0"
                let expr_68 := 0x00
                /// @src 0:685:691  "n == 0"
                let expr_69 := eq(cleanup_t_uint256(expr_67), convert_t_rational_0_by_1_to_t_uint256(expr_68))
                /// @src 0:681:701  "if (n == 0) return 1"
                if expr_69 {
                    /// @src 0:700:701  "1"
                    let expr_70 := 0x01
                    /// @src 0:693:701  "return 1"
                    var__65 := convert_t_rational_1_by_1_to_t_uint256(expr_70)
                    leave
                    /// @src 0:681:701  "if (n == 0) return 1"
                }
                /// @src 0:737:738  "1"
                let expr_75 := 0x01
                /// @src 0:720:738  "uint256 result = 1"
                let var_result_74 := convert_t_rational_1_by_1_to_t_uint256(expr_75)
                /// @src 0:760:761  "n"
                let _53 := var_n_62
                let expr_79 := _53
                /// @src 0:748:761  "uint256 i = n"
                let var_i_78 := expr_79
                /// @src 0:771:838  "while (i > 0) {..."
                for {
                    } 1 {
                }
                {
                    /// @src 0:778:779  "i"
                    let _54 := var_i_78
                    let expr_81 := _54
                    /// @src 0:782:783  "0"
                    let expr_82 := 0x00
                    /// @src 0:778:783  "i > 0"
                    let expr_83 := gt(cleanup_t_uint256(expr_81), convert_t_rational_0_by_1_to_t_uint256(expr_82))
                    if iszero(expr_83) { break }
                    /// @src 0:809:810  "i"
                    let _55 := var_i_78
                    let expr_85 := _55
                    /// @src 0:799:810  "result *= i"
                    let _56 := var_result_74
                    let expr_86 := checked_mul_t_uint256(_56, expr_85)

                    var_result_74 := expr_86
                    /// @src 0:824:827  "i--"
                    let _58 := var_i_78
                    let _57 := decrement_t_uint256(_58)
                    var_i_78 := _57
                    let expr_89 := _58
                }
                /// @src 0:854:860  "result"
                let _59 := var_result_74
                let expr_93 := _59
                /// @src 0:847:860  "return result"
                var__65 := expr_93
                leave

            }
            /// @src 0:57:2235  "contract ControlFlow {..."

        }

        data ".metadata" hex"a264697066735822122091d3a346b29decba361ae1a47f1298d5040d6b097eeeb64bd43f5013374a44f564736f6c634300081e0033"
    }

}

