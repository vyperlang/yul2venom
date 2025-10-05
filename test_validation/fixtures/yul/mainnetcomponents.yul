
/// @use-src 0:"test_validation/fixtures/solidity/MainnetComponents.sol"
object "ABIPatterns_360" {
    code {
        /// @src 0:2624:3187  "contract ABIPatterns {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        constructor_ABIPatterns_360()

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("ABIPatterns_360_deployed"), datasize("ABIPatterns_360_deployed"))

        return(_1, datasize("ABIPatterns_360_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:2624:3187  "contract ABIPatterns {..."
        function constructor_ABIPatterns_360() {

            /// @src 0:2624:3187  "contract ABIPatterns {..."

        }
        /// @src 0:2624:3187  "contract ABIPatterns {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/MainnetComponents.sol"
    object "ABIPatterns_360_deployed" {
        code {
            /// @src 0:2624:3187  "contract ABIPatterns {..."
            mstore(64, memoryguard(128))

            if iszero(lt(calldatasize(), 4))
            {
                let selector := shift_right_224_unsigned(calldataload(0))
                switch selector

                case 0x9a1054f0
                {
                    // encodePacked(address,uint256)

                    external_fun_encodePacked_347()
                }

                case 0xcde99e63
                {
                    // decodeSwapData(bytes)

                    external_fun_decodeSwapData_331()
                }

                case 0xe66ef92d
                {
                    // hashData(bytes)

                    external_fun_hashData_359()
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

            function cleanup_t_uint160(value) -> cleaned {
                cleaned := and(value, 0xffffffffffffffffffffffffffffffffffffffff)
            }

            function cleanup_t_address(value) -> cleaned {
                cleaned := cleanup_t_uint160(value)
            }

            function validator_revert_t_address(value) {
                if iszero(eq(value, cleanup_t_address(value))) { revert(0, 0) }
            }

            function abi_decode_t_address(offset, end) -> value {
                value := calldataload(offset)
                validator_revert_t_address(value)
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

            function abi_decode_tuple_t_addresst_uint256(headStart, dataEnd) -> value0, value1 {
                if slt(sub(dataEnd, headStart), 64) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := 0

                    value0 := abi_decode_t_address(add(headStart, offset), dataEnd)
                }

                {

                    let offset := 32

                    value1 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
                }

            }

            function array_length_t_bytes_memory_ptr(value) -> length {

                length := mload(value)

            }

            function array_storeLengthForEncoding_t_bytes_memory_ptr_fromStack(pos, length) -> updated_pos {
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

            function abi_encode_t_bytes_memory_ptr_to_t_bytes_memory_ptr_fromStack(value, pos) -> end {
                let length := array_length_t_bytes_memory_ptr(value)
                pos := array_storeLengthForEncoding_t_bytes_memory_ptr_fromStack(pos, length)
                copy_memory_to_memory_with_cleanup(add(value, 0x20), pos, length)
                end := add(pos, round_up_to_mul_of_32(length))
            }

            function abi_encode_tuple_t_bytes_memory_ptr__to_t_bytes_memory_ptr__fromStack(headStart , value0) -> tail {
                tail := add(headStart, 32)

                mstore(add(headStart, 0), sub(tail, headStart))
                tail := abi_encode_t_bytes_memory_ptr_to_t_bytes_memory_ptr_fromStack(value0,  tail)

            }

            function external_fun_encodePacked_347() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1 :=  abi_decode_tuple_t_addresst_uint256(4, calldatasize())
                let ret_0 :=  fun_encodePacked_347(param_0, param_1)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_bytes_memory_ptr__to_t_bytes_memory_ptr__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function revert_error_1b9f4a0a5773e33b91aa01db23bf8c55fce1411167c872835e7fa00a4f17d46d() {
                revert(0, 0)
            }

            function revert_error_15abf5612cd996bc235ba1e55a4a30ac60e6bb601ff7ba4ad3f179b6be8d0490() {
                revert(0, 0)
            }

            function revert_error_81385d8c0b31fffe14be1da910c8bd3a80be4cfa248e04f42ec0faea3132a8ef() {
                revert(0, 0)
            }

            // bytes
            function abi_decode_t_bytes_calldata_ptr(offset, end) -> arrayPos, length {
                if iszero(slt(add(offset, 0x1f), end)) { revert_error_1b9f4a0a5773e33b91aa01db23bf8c55fce1411167c872835e7fa00a4f17d46d() }
                length := calldataload(offset)
                if gt(length, 0xffffffffffffffff) { revert_error_15abf5612cd996bc235ba1e55a4a30ac60e6bb601ff7ba4ad3f179b6be8d0490() }
                arrayPos := add(offset, 0x20)
                if gt(add(arrayPos, mul(length, 0x01)), end) { revert_error_81385d8c0b31fffe14be1da910c8bd3a80be4cfa248e04f42ec0faea3132a8ef() }
            }

            function abi_decode_tuple_t_bytes_calldata_ptr(headStart, dataEnd) -> value0, value1 {
                if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := calldataload(add(headStart, 0))
                    if gt(offset, 0xffffffffffffffff) { revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() }

                    value0, value1 := abi_decode_t_bytes_calldata_ptr(add(headStart, offset), dataEnd)
                }

            }

            function abi_encode_t_address_to_t_address(value, pos) {
                mstore(pos, cleanup_t_address(value))
            }

            function abi_encode_t_uint256_to_t_uint256(value, pos) {
                mstore(pos, cleanup_t_uint256(value))
            }

            function array_storeLengthForEncoding_t_bytes_memory_ptr(pos, length) -> updated_pos {
                mstore(pos, length)
                updated_pos := add(pos, 0x20)
            }

            function abi_encode_t_bytes_memory_ptr_to_t_bytes_memory_ptr(value, pos) -> end {
                let length := array_length_t_bytes_memory_ptr(value)
                pos := array_storeLengthForEncoding_t_bytes_memory_ptr(pos, length)
                copy_memory_to_memory_with_cleanup(add(value, 0x20), pos, length)
                end := add(pos, round_up_to_mul_of_32(length))
            }

            // struct ABIPatterns.SwapData -> struct ABIPatterns.SwapData
            function abi_encode_t_struct$_SwapData_$315_memory_ptr_to_t_struct$_SwapData_$315_memory_ptr_fromStack(value, pos)  -> end  {
                let tail := add(pos, 0xa0)

                {
                    // tokenIn

                    let memberValue0 := mload(add(value, 0x00))
                    abi_encode_t_address_to_t_address(memberValue0, add(pos, 0x00))
                }

                {
                    // tokenOut

                    let memberValue0 := mload(add(value, 0x20))
                    abi_encode_t_address_to_t_address(memberValue0, add(pos, 0x20))
                }

                {
                    // amountIn

                    let memberValue0 := mload(add(value, 0x40))
                    abi_encode_t_uint256_to_t_uint256(memberValue0, add(pos, 0x40))
                }

                {
                    // amountOutMin

                    let memberValue0 := mload(add(value, 0x60))
                    abi_encode_t_uint256_to_t_uint256(memberValue0, add(pos, 0x60))
                }

                {
                    // path

                    let memberValue0 := mload(add(value, 0x80))

                    mstore(add(pos, 0x80), sub(tail, pos))
                    tail := abi_encode_t_bytes_memory_ptr_to_t_bytes_memory_ptr(memberValue0, tail)

                }

                end := tail
            }

            function abi_encode_tuple_t_struct$_SwapData_$315_memory_ptr__to_t_struct$_SwapData_$315_memory_ptr__fromStack(headStart , value0) -> tail {
                tail := add(headStart, 32)

                mstore(add(headStart, 0), sub(tail, headStart))
                tail := abi_encode_t_struct$_SwapData_$315_memory_ptr_to_t_struct$_SwapData_$315_memory_ptr_fromStack(value0,  tail)

            }

            function external_fun_decodeSwapData_331() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1 :=  abi_decode_tuple_t_bytes_calldata_ptr(4, calldatasize())
                let ret_0 :=  fun_decodeSwapData_331(param_0, param_1)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_struct$_SwapData_$315_memory_ptr__to_t_struct$_SwapData_$315_memory_ptr__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function revert_error_987264b3b1d58a9c7f8255e93e81c77d86d6299019c33110a076957a3e06e2ae() {
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

            function array_allocation_size_t_bytes_memory_ptr(length) -> size {
                // Make sure we can allocate memory without overflow
                if gt(length, 0xffffffffffffffff) { panic_error_0x41() }

                size := round_up_to_mul_of_32(length)

                // add length slot
                size := add(size, 0x20)

            }

            function copy_calldata_to_memory_with_cleanup(src, dst, length) {

                calldatacopy(dst, src, length)
                mstore(add(dst, length), 0)

            }

            function abi_decode_available_length_t_bytes_memory_ptr(src, length, end) -> array {
                array := allocate_memory(array_allocation_size_t_bytes_memory_ptr(length))
                mstore(array, length)
                let dst := add(array, 0x20)
                if gt(add(src, length), end) { revert_error_987264b3b1d58a9c7f8255e93e81c77d86d6299019c33110a076957a3e06e2ae() }
                copy_calldata_to_memory_with_cleanup(src, dst, length)
            }

            // bytes
            function abi_decode_t_bytes_memory_ptr(offset, end) -> array {
                if iszero(slt(add(offset, 0x1f), end)) { revert_error_1b9f4a0a5773e33b91aa01db23bf8c55fce1411167c872835e7fa00a4f17d46d() }
                let length := calldataload(offset)
                array := abi_decode_available_length_t_bytes_memory_ptr(add(offset, 0x20), length, end)
            }

            function abi_decode_tuple_t_bytes_memory_ptr(headStart, dataEnd) -> value0 {
                if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := calldataload(add(headStart, 0))
                    if gt(offset, 0xffffffffffffffff) { revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() }

                    value0 := abi_decode_t_bytes_memory_ptr(add(headStart, offset), dataEnd)
                }

            }

            function cleanup_t_bytes32(value) -> cleaned {
                cleaned := value
            }

            function abi_encode_t_bytes32_to_t_bytes32_fromStack(value, pos) {
                mstore(pos, cleanup_t_bytes32(value))
            }

            function abi_encode_tuple_t_bytes32__to_t_bytes32__fromStack(headStart , value0) -> tail {
                tail := add(headStart, 32)

                abi_encode_t_bytes32_to_t_bytes32_fromStack(value0,  add(headStart, 0))

            }

            function external_fun_hashData_359() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_bytes_memory_ptr(4, calldatasize())
                let ret_0 :=  fun_hashData_359(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_bytes32__to_t_bytes32__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function revert_error_42b3090547df1d2001c96683413b8cf91c1b902ef5e3cb8d9f6f304cf7446f74() {
                revert(0, 0)
            }

            function zero_value_for_split_t_bytes_memory_ptr() -> ret {
                ret := 96
            }

            function shift_left_96(value) -> newValue {
                newValue :=

                shl(96, value)

            }

            function leftAlign_t_uint160(value) -> aligned {
                aligned := shift_left_96(value)
            }

            function leftAlign_t_address(value) -> aligned {
                aligned := leftAlign_t_uint160(value)
            }

            function abi_encode_t_address_to_t_address_nonPadded_inplace_fromStack(value, pos) {
                mstore(pos, leftAlign_t_address(cleanup_t_address(value)))
            }

            function leftAlign_t_uint256(value) -> aligned {
                aligned := value
            }

            function abi_encode_t_uint256_to_t_uint256_nonPadded_inplace_fromStack(value, pos) {
                mstore(pos, leftAlign_t_uint256(cleanup_t_uint256(value)))
            }

            function abi_encode_tuple_packed_t_address_t_uint256__to_t_address_t_uint256__nonPadded_inplace_fromStack(pos , value0, value1) -> end {

                abi_encode_t_address_to_t_address_nonPadded_inplace_fromStack(value0,  pos)
                pos := add(pos, 20)

                abi_encode_t_uint256_to_t_uint256_nonPadded_inplace_fromStack(value1,  pos)
                pos := add(pos, 32)

                end := pos
            }

            /// @ast-id 347
            /// @src 0:2948:3073  "function encodePacked(address a, uint256 b) public pure returns (bytes memory) {..."
            function fun_encodePacked_347(var_a_333, var_b_335) -> var__338_mpos {
                /// @src 0:3013:3025  "bytes memory"
                let zero_t_bytes_memory_ptr_1_mpos := zero_value_for_split_t_bytes_memory_ptr()
                var__338_mpos := zero_t_bytes_memory_ptr_1_mpos

                /// @src 0:3061:3062  "a"
                let _2 := var_a_333
                let expr_342 := _2
                /// @src 0:3064:3065  "b"
                let _3 := var_b_335
                let expr_343 := _3
                /// @src 0:3044:3066  "abi.encodePacked(a, b)"

                let expr_344_mpos := allocate_unbounded()
                let _4 := add(expr_344_mpos, 0x20)

                let _5 := abi_encode_tuple_packed_t_address_t_uint256__to_t_address_t_uint256__nonPadded_inplace_fromStack(_4, expr_342, expr_343)
                mstore(expr_344_mpos, sub(_5, add(expr_344_mpos, 0x20)))
                finalize_allocation(expr_344_mpos, sub(_5, expr_344_mpos))
                /// @src 0:3037:3066  "return abi.encodePacked(a, b)"
                var__338_mpos := expr_344_mpos
                leave

            }
            /// @src 0:2624:3187  "contract ABIPatterns {..."

            function allocate_memory_struct_t_struct$_SwapData_$315_memory_ptr() -> memPtr {
                memPtr := allocate_memory(160)
            }

            function zero_value_for_t_address() -> ret {
                ret := 0
            }

            function zero_value_for_t_uint256() -> ret {
                ret := 0
            }

            function zero_value_for_t_bytes_memory_ptr() -> ret {
                ret := 96
            }

            function allocate_and_zero_memory_struct_t_struct$_SwapData_$315_memory_ptr() -> memPtr {
                memPtr := allocate_memory_struct_t_struct$_SwapData_$315_memory_ptr()
                let offset := memPtr

                mstore(offset, zero_value_for_t_address())
                offset := add(offset, 32)

                mstore(offset, zero_value_for_t_address())
                offset := add(offset, 32)

                mstore(offset, zero_value_for_t_uint256())
                offset := add(offset, 32)

                mstore(offset, zero_value_for_t_uint256())
                offset := add(offset, 32)

                mstore(offset, zero_value_for_t_bytes_memory_ptr())
                offset := add(offset, 32)

            }

            function zero_value_for_split_t_struct$_SwapData_$315_memory_ptr() -> ret {
                ret := allocate_and_zero_memory_struct_t_struct$_SwapData_$315_memory_ptr()
            }

            function revert_error_3538a459e4a0eb828f1aed5ebe5dc96fe59620a31d9b33e41259bb820cae769f() {
                revert(0, 0)
            }

            function revert_error_5e8f644817bc4960744f35c15999b6eff64ae702f94b1c46297cfd4e1aec2421() {
                revert(0, 0)
            }

            // struct ABIPatterns.SwapData
            function abi_decode_t_struct$_SwapData_$315_memory_ptr(headStart, end) -> value {
                if slt(sub(end, headStart), 0xa0) { revert_error_3538a459e4a0eb828f1aed5ebe5dc96fe59620a31d9b33e41259bb820cae769f() }
                value := allocate_memory(0xa0)

                {
                    // tokenIn

                    let offset := 0

                    mstore(add(value, 0x00), abi_decode_t_address(add(headStart, offset), end))

                }

                {
                    // tokenOut

                    let offset := 32

                    mstore(add(value, 0x20), abi_decode_t_address(add(headStart, offset), end))

                }

                {
                    // amountIn

                    let offset := 64

                    mstore(add(value, 0x40), abi_decode_t_uint256(add(headStart, offset), end))

                }

                {
                    // amountOutMin

                    let offset := 96

                    mstore(add(value, 0x60), abi_decode_t_uint256(add(headStart, offset), end))

                }

                {
                    // path

                    let offset := calldataload(add(headStart, 128))
                    if gt(offset, 0xffffffffffffffff) { revert_error_5e8f644817bc4960744f35c15999b6eff64ae702f94b1c46297cfd4e1aec2421() }

                    mstore(add(value, 0x80), abi_decode_t_bytes_memory_ptr(add(headStart, offset), end))

                }

            }

            function abi_decode_tuple_t_struct$_SwapData_$315_memory_ptr(headStart, dataEnd) -> value0 {
                if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := calldataload(add(headStart, 0))
                    if gt(offset, 0xffffffffffffffff) { revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() }

                    value0 := abi_decode_t_struct$_SwapData_$315_memory_ptr(add(headStart, offset), dataEnd)
                }

            }

            /// @ast-id 331
            /// @src 0:2807:2942  "function decodeSwapData(bytes calldata data) public pure returns (SwapData memory) {..."
            function fun_decodeSwapData_331(var_data_317_offset, var_data_317_length) -> var__321_mpos {
                /// @src 0:2873:2888  "SwapData memory"
                let zero_t_struct$_SwapData_$315_memory_ptr_6_mpos := zero_value_for_split_t_struct$_SwapData_$315_memory_ptr()
                var__321_mpos := zero_t_struct$_SwapData_$315_memory_ptr_6_mpos

                /// @src 0:2918:2922  "data"
                let _7_offset := var_data_317_offset
                let _7_length := var_data_317_length
                let expr_325_offset := _7_offset
                let expr_325_length := _7_length
                /// @src 0:2907:2935  "abi.decode(data, (SwapData))"

                let expr_328_mpos :=  abi_decode_tuple_t_struct$_SwapData_$315_memory_ptr(expr_325_offset, add(expr_325_offset, expr_325_length))
                /// @src 0:2900:2935  "return abi.decode(data, (SwapData))"
                var__321_mpos := expr_328_mpos
                leave

            }
            /// @src 0:2624:3187  "contract ABIPatterns {..."

            function zero_value_for_split_t_bytes32() -> ret {
                ret := 0
            }

            function array_dataslot_t_bytes_memory_ptr(ptr) -> data {
                data := ptr

                data := add(ptr, 0x20)

            }

            /// @ast-id 359
            /// @src 0:3079:3185  "function hashData(bytes memory data) public pure returns (bytes32) {..."
            function fun_hashData_359(var_data_349_mpos) -> var__352 {
                /// @src 0:3137:3144  "bytes32"
                let zero_t_bytes32_8 := zero_value_for_split_t_bytes32()
                var__352 := zero_t_bytes32_8

                /// @src 0:3173:3177  "data"
                let _9_mpos := var_data_349_mpos
                let expr_355_mpos := _9_mpos
                /// @src 0:3163:3178  "keccak256(data)"
                let expr_356 := keccak256(array_dataslot_t_bytes_memory_ptr(expr_355_mpos), array_length_t_bytes_memory_ptr(expr_355_mpos))
                /// @src 0:3156:3178  "return keccak256(data)"
                var__352 := expr_356
                leave

            }
            /// @src 0:2624:3187  "contract ABIPatterns {..."

        }

        data ".metadata" hex"a26469706673582212203866bb6fa8d625c452ab32ed7a1e2241c98c576b5e3ba22ebb810013fdb02e7864736f6c634300081e0033"
    }

}




/// @use-src 0:"test_validation/fixtures/solidity/MainnetComponents.sol"
object "ControlFlowPatterns_679" {
    code {
        /// @src 0:4666:5652  "contract ControlFlowPatterns {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        constructor_ControlFlowPatterns_679()

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("ControlFlowPatterns_679_deployed"), datasize("ControlFlowPatterns_679_deployed"))

        return(_1, datasize("ControlFlowPatterns_679_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:4666:5652  "contract ControlFlowPatterns {..."
        function constructor_ControlFlowPatterns_679() {

            /// @src 0:4666:5652  "contract ControlFlowPatterns {..."

        }
        /// @src 0:4666:5652  "contract ControlFlowPatterns {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/MainnetComponents.sol"
    object "ControlFlowPatterns_679_deployed" {
        code {
            /// @src 0:4666:5652  "contract ControlFlowPatterns {..."
            mstore(64, memoryguard(128))

            if iszero(lt(calldatasize(), 4))
            {
                let selector := shift_right_224_unsigned(calldataload(0))
                switch selector

                case 0x61047ff4
                {
                    // fibonacci(uint256)

                    external_fun_fibonacci_595()
                }

                case 0x629e944c
                {
                    // switchCase(uint256)

                    external_fun_switchCase_678()
                }

                case 0x8bd58682
                {
                    // findMax(uint256[])

                    external_fun_findMax_646()
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

            function external_fun_fibonacci_595() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                let ret_0 :=  fun_fibonacci_595(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

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

            function external_fun_switchCase_678() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                let ret_0 :=  fun_switchCase_678(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_string_memory_ptr__to_t_string_memory_ptr__fromStack(memPos , ret_0)
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

            function external_fun_findMax_646() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_array$_t_uint256_$dyn_memory_ptr(4, calldatasize())
                let ret_0 :=  fun_findMax_646(param_0)
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

            function cleanup_t_rational_1_by_1(value) -> cleaned {
                cleaned := value
            }

            function identity(value) -> ret {
                ret := value
            }

            function convert_t_rational_1_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_1_by_1(value)))
            }

            function cleanup_t_rational_0_by_1(value) -> cleaned {
                cleaned := value
            }

            function convert_t_rational_0_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_0_by_1(value)))
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

            function increment_t_uint256(value) -> ret {
                value := cleanup_t_uint256(value)
                if eq(value, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) { panic_error_0x11() }
                ret := add(value, 1)
            }

            function checked_add_t_uint256(x, y) -> sum {
                x := cleanup_t_uint256(x)
                y := cleanup_t_uint256(y)
                sum := add(x, y)

                if gt(x, sum) { panic_error_0x11() }

            }

            /// @ast-id 595
            /// @src 0:4701:4993  "function fibonacci(uint256 n) public pure returns (uint256) {..."
            function fun_fibonacci_595(var_n_547) -> var__550 {
                /// @src 0:4752:4759  "uint256"
                let zero_t_uint256_1 := zero_value_for_split_t_uint256()
                var__550 := zero_t_uint256_1

                /// @src 0:4775:4776  "n"
                let _2 := var_n_547
                let expr_552 := _2
                /// @src 0:4780:4781  "1"
                let expr_553 := 0x01
                /// @src 0:4775:4781  "n <= 1"
                let expr_554 := iszero(gt(cleanup_t_uint256(expr_552), convert_t_rational_1_by_1_to_t_uint256(expr_553)))
                /// @src 0:4771:4791  "if (n <= 1) return n"
                if expr_554 {
                    /// @src 0:4790:4791  "n"
                    let _3 := var_n_547
                    let expr_555 := _3
                    /// @src 0:4783:4791  "return n"
                    var__550 := expr_555
                    leave
                    /// @src 0:4771:4791  "if (n <= 1) return n"
                }
                /// @src 0:4814:4815  "0"
                let expr_560 := 0x00
                /// @src 0:4802:4815  "uint256 a = 0"
                let var_a_559 := convert_t_rational_0_by_1_to_t_uint256(expr_560)
                /// @src 0:4837:4838  "1"
                let expr_564 := 0x01
                /// @src 0:4825:4838  "uint256 b = 1"
                let var_b_563 := convert_t_rational_1_by_1_to_t_uint256(expr_564)
                /// @src 0:4849:4968  "for (uint256 i = 2; i <= n; i++) {..."
                for {
                    /// @src 0:4866:4867  "2"
                    let expr_568 := 0x02
                    /// @src 0:4854:4867  "uint256 i = 2"
                    let var_i_567 := convert_t_rational_2_by_1_to_t_uint256(expr_568)
                    } 1 {
                    /// @src 0:4877:4880  "i++"
                    let _5 := var_i_567
                    let _4 := increment_t_uint256(_5)
                    var_i_567 := _4
                    let expr_574 := _5
                }
                {
                    /// @src 0:4869:4870  "i"
                    let _6 := var_i_567
                    let expr_570 := _6
                    /// @src 0:4874:4875  "n"
                    let _7 := var_n_547
                    let expr_571 := _7
                    /// @src 0:4869:4875  "i <= n"
                    let expr_572 := iszero(gt(cleanup_t_uint256(expr_570), cleanup_t_uint256(expr_571)))
                    if iszero(expr_572) { break }
                    /// @src 0:4911:4912  "a"
                    let _8 := var_a_559
                    let expr_578 := _8
                    /// @src 0:4915:4916  "b"
                    let _9 := var_b_563
                    let expr_579 := _9
                    /// @src 0:4911:4916  "a + b"
                    let expr_580 := checked_add_t_uint256(expr_578, expr_579)

                    /// @src 0:4896:4916  "uint256 temp = a + b"
                    let var_temp_577 := expr_580
                    /// @src 0:4934:4935  "b"
                    let _10 := var_b_563
                    let expr_583 := _10
                    /// @src 0:4930:4935  "a = b"
                    var_a_559 := expr_583
                    let expr_584 := expr_583
                    /// @src 0:4953:4957  "temp"
                    let _11 := var_temp_577
                    let expr_587 := _11
                    /// @src 0:4949:4957  "b = temp"
                    var_b_563 := expr_587
                    let expr_588 := expr_587
                }
                /// @src 0:4985:4986  "b"
                let _12 := var_b_563
                let expr_592 := _12
                /// @src 0:4978:4986  "return b"
                var__550 := expr_592
                leave

            }
            /// @src 0:4666:5652  "contract ControlFlowPatterns {..."

            function zero_value_for_split_t_string_memory_ptr() -> ret {
                ret := 96
            }

            function cleanup_t_rational_3_by_1(value) -> cleaned {
                cleaned := value
            }

            function convert_t_rational_3_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_3_by_1(value)))
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

            function store_literal_in_memory_2388ace4b6c74bf1d37ee3a2fa37b787d525b289aa879f2d9bedf3eddf0fbedd(memPtr) {

                mstore(add(memPtr, 0), "Default")

            }

            function copy_literal_to_memory_2388ace4b6c74bf1d37ee3a2fa37b787d525b289aa879f2d9bedf3eddf0fbedd() -> memPtr {
                memPtr := allocate_memory_array_t_string_memory_ptr(7)
                store_literal_in_memory_2388ace4b6c74bf1d37ee3a2fa37b787d525b289aa879f2d9bedf3eddf0fbedd(add(memPtr, 32))
            }

            function convert_t_stringliteral_2388ace4b6c74bf1d37ee3a2fa37b787d525b289aa879f2d9bedf3eddf0fbedd_to_t_string_memory_ptr() -> converted {
                converted := copy_literal_to_memory_2388ace4b6c74bf1d37ee3a2fa37b787d525b289aa879f2d9bedf3eddf0fbedd()
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

            /// @ast-id 678
            /// @src 0:5318:5650  "function switchCase(uint256 option) public pure returns (string memory) {..."
            function fun_switchCase_678(var_option_648) -> var__651_mpos {
                /// @src 0:5375:5388  "string memory"
                let zero_t_string_memory_ptr_13_mpos := zero_value_for_split_t_string_memory_ptr()
                var__651_mpos := zero_t_string_memory_ptr_13_mpos

                /// @src 0:5404:5410  "option"
                let _14 := var_option_648
                let expr_653 := _14
                /// @src 0:5414:5415  "1"
                let expr_654 := 0x01
                /// @src 0:5404:5415  "option == 1"
                let expr_655 := eq(cleanup_t_uint256(expr_653), convert_t_rational_1_by_1_to_t_uint256(expr_654))
                /// @src 0:5400:5644  "if (option == 1) {..."
                switch expr_655
                case 0 {
                    /// @src 0:5471:5477  "option"
                    let _15 := var_option_648
                    let expr_659 := _15
                    /// @src 0:5481:5482  "2"
                    let expr_660 := 0x02
                    /// @src 0:5471:5482  "option == 2"
                    let expr_661 := eq(cleanup_t_uint256(expr_659), convert_t_rational_2_by_1_to_t_uint256(expr_660))
                    /// @src 0:5467:5644  "if (option == 2) {..."
                    switch expr_661
                    case 0 {
                        /// @src 0:5538:5544  "option"
                        let _16 := var_option_648
                        let expr_665 := _16
                        /// @src 0:5548:5549  "3"
                        let expr_666 := 0x03
                        /// @src 0:5538:5549  "option == 3"
                        let expr_667 := eq(cleanup_t_uint256(expr_665), convert_t_rational_3_by_1_to_t_uint256(expr_666))
                        /// @src 0:5534:5644  "if (option == 3) {..."
                        switch expr_667
                        case 0 {
                            /// @src 0:5617:5633  "return \"Default\""
                            var__651_mpos := convert_t_stringliteral_2388ace4b6c74bf1d37ee3a2fa37b787d525b289aa879f2d9bedf3eddf0fbedd_to_t_string_memory_ptr()
                            leave
                            /// @src 0:5534:5644  "if (option == 3) {..."
                        }
                        default {
                            /// @src 0:5565:5586  "return \"Option Three\""
                            var__651_mpos := convert_t_stringliteral_a526a9df55d08e4c040274c9ac30865b447b072cded054f4d645bb45ec622033_to_t_string_memory_ptr()
                            leave
                            /// @src 0:5534:5644  "if (option == 3) {..."
                        }
                        /// @src 0:5467:5644  "if (option == 2) {..."
                    }
                    default {
                        /// @src 0:5498:5517  "return \"Option Two\""
                        var__651_mpos := convert_t_stringliteral_f1cc0686348a60e76c02dc469e0b20ddcc1d88569596675b7f2e99b9470ae60c_to_t_string_memory_ptr()
                        leave
                        /// @src 0:5467:5644  "if (option == 2) {..."
                    }
                    /// @src 0:5400:5644  "if (option == 1) {..."
                }
                default {
                    /// @src 0:5431:5450  "return \"Option One\""
                    var__651_mpos := convert_t_stringliteral_eadc37320786f22b6052e09910bee266c3c6128732fa7777d5d7b5e1981faa23_to_t_string_memory_ptr()
                    leave
                    /// @src 0:5400:5644  "if (option == 1) {..."
                }

            }
            /// @src 0:4666:5652  "contract ControlFlowPatterns {..."

            function array_length_t_array$_t_uint256_$dyn_memory_ptr(value) -> length {

                length := mload(value)

            }

            function store_literal_in_memory_bf73f56512aea83317326e1162a9bcc77b65bc22b70591fcb7fa0e183370b7cf(memPtr) {

                mstore(add(memPtr, 0), "Empty array")

            }

            function abi_encode_t_stringliteral_bf73f56512aea83317326e1162a9bcc77b65bc22b70591fcb7fa0e183370b7cf_to_t_string_memory_ptr_fromStack(pos) -> end {
                pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 11)
                store_literal_in_memory_bf73f56512aea83317326e1162a9bcc77b65bc22b70591fcb7fa0e183370b7cf(pos)
                end := add(pos, 32)
            }

            function abi_encode_tuple_t_stringliteral_bf73f56512aea83317326e1162a9bcc77b65bc22b70591fcb7fa0e183370b7cf__to_t_string_memory_ptr__fromStack(headStart ) -> tail {
                tail := add(headStart, 32)

                mstore(add(headStart, 0), sub(tail, headStart))
                tail := abi_encode_t_stringliteral_bf73f56512aea83317326e1162a9bcc77b65bc22b70591fcb7fa0e183370b7cf_to_t_string_memory_ptr_fromStack( tail)

            }

            function require_helper_t_stringliteral_bf73f56512aea83317326e1162a9bcc77b65bc22b70591fcb7fa0e183370b7cf(condition ) {
                if iszero(condition)
                {

                    let memPtr := allocate_unbounded()

                    mstore(memPtr, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                    let end := abi_encode_tuple_t_stringliteral_bf73f56512aea83317326e1162a9bcc77b65bc22b70591fcb7fa0e183370b7cf__to_t_string_memory_ptr__fromStack(add(memPtr, 4) )
                    revert(memPtr, sub(end, memPtr))
                }
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

            function increment_wrapping_t_uint256(value) -> ret {
                ret := cleanup_t_uint256(add(value, 1))
            }

            /// @ast-id 646
            /// @src 0:4999:5312  "function findMax(uint256[] memory arr) public pure returns (uint256) {..."
            function fun_findMax_646(var_arr_598_mpos) -> var__601 {
                /// @src 0:5059:5066  "uint256"
                let zero_t_uint256_17 := zero_value_for_split_t_uint256()
                var__601 := zero_t_uint256_17

                /// @src 0:5086:5089  "arr"
                let _18_mpos := var_arr_598_mpos
                let expr_604_mpos := _18_mpos
                /// @src 0:5086:5096  "arr.length"
                let expr_605 := array_length_t_array$_t_uint256_$dyn_memory_ptr(expr_604_mpos)
                /// @src 0:5099:5100  "0"
                let expr_606 := 0x00
                /// @src 0:5086:5100  "arr.length > 0"
                let expr_607 := gt(cleanup_t_uint256(expr_605), convert_t_rational_0_by_1_to_t_uint256(expr_606))
                /// @src 0:5078:5116  "require(arr.length > 0, \"Empty array\")"
                require_helper_t_stringliteral_bf73f56512aea83317326e1162a9bcc77b65bc22b70591fcb7fa0e183370b7cf(expr_607)
                /// @src 0:5141:5144  "arr"
                let _19_mpos := var_arr_598_mpos
                let expr_613_mpos := _19_mpos
                /// @src 0:5145:5146  "0"
                let expr_614 := 0x00
                /// @src 0:5141:5147  "arr[0]"
                let _20 := read_from_memoryt_uint256(memory_array_index_access_t_array$_t_uint256_$dyn_memory_ptr(expr_613_mpos, convert_t_rational_0_by_1_to_t_uint256(expr_614)))
                let expr_615 := _20
                /// @src 0:5127:5147  "uint256 max = arr[0]"
                let var_max_612 := expr_615
                /// @src 0:5157:5285  "for (uint256 i = 1; i < arr.length; i++) {..."
                for {
                    /// @src 0:5174:5175  "1"
                    let expr_619 := 0x01
                    /// @src 0:5162:5175  "uint256 i = 1"
                    let var_i_618 := convert_t_rational_1_by_1_to_t_uint256(expr_619)
                    } 1 {
                    /// @src 0:5193:5196  "i++"
                    let _22 := var_i_618
                    let _21 := increment_wrapping_t_uint256(_22)
                    var_i_618 := _21
                    let expr_626 := _22
                }
                {
                    /// @src 0:5177:5178  "i"
                    let _23 := var_i_618
                    let expr_621 := _23
                    /// @src 0:5181:5184  "arr"
                    let _24_mpos := var_arr_598_mpos
                    let expr_622_mpos := _24_mpos
                    /// @src 0:5181:5191  "arr.length"
                    let expr_623 := array_length_t_array$_t_uint256_$dyn_memory_ptr(expr_622_mpos)
                    /// @src 0:5177:5191  "i < arr.length"
                    let expr_624 := lt(cleanup_t_uint256(expr_621), cleanup_t_uint256(expr_623))
                    if iszero(expr_624) { break }
                    /// @src 0:5216:5219  "arr"
                    let _25_mpos := var_arr_598_mpos
                    let expr_628_mpos := _25_mpos
                    /// @src 0:5220:5221  "i"
                    let _26 := var_i_618
                    let expr_629 := _26
                    /// @src 0:5216:5222  "arr[i]"
                    let _27 := read_from_memoryt_uint256(memory_array_index_access_t_array$_t_uint256_$dyn_memory_ptr(expr_628_mpos, expr_629))
                    let expr_630 := _27
                    /// @src 0:5225:5228  "max"
                    let _28 := var_max_612
                    let expr_631 := _28
                    /// @src 0:5216:5228  "arr[i] > max"
                    let expr_632 := gt(cleanup_t_uint256(expr_630), cleanup_t_uint256(expr_631))
                    /// @src 0:5212:5275  "if (arr[i] > max) {..."
                    if expr_632 {
                        /// @src 0:5254:5257  "arr"
                        let _29_mpos := var_arr_598_mpos
                        let expr_634_mpos := _29_mpos
                        /// @src 0:5258:5259  "i"
                        let _30 := var_i_618
                        let expr_635 := _30
                        /// @src 0:5254:5260  "arr[i]"
                        let _31 := read_from_memoryt_uint256(memory_array_index_access_t_array$_t_uint256_$dyn_memory_ptr(expr_634_mpos, expr_635))
                        let expr_636 := _31
                        /// @src 0:5248:5260  "max = arr[i]"
                        var_max_612 := expr_636
                        let expr_637 := expr_636
                        /// @src 0:5212:5275  "if (arr[i] > max) {..."
                    }
                }
                /// @src 0:5302:5305  "max"
                let _32 := var_max_612
                let expr_643 := _32
                /// @src 0:5295:5305  "return max"
                var__601 := expr_643
                leave

            }
            /// @src 0:4666:5652  "contract ControlFlowPatterns {..."

        }

        data ".metadata" hex"a26469706673582212201afa94be168fd5bf9fd175f88f32e5a10e0cc780ece2c24b18d2bdd109b65eda64736f6c634300081e0033"
    }

}




/// @use-src 0:"test_validation/fixtures/solidity/MainnetComponents.sol"
object "ErrorHandling_444" {
    code {
        /// @src 0:3189:3981  "contract ErrorHandling {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        constructor_ErrorHandling_444()

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("ErrorHandling_444_deployed"), datasize("ErrorHandling_444_deployed"))

        return(_1, datasize("ErrorHandling_444_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
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

        function cleanup_t_rational_1000_by_1(value) -> cleaned {
            cleaned := value
        }

        function cleanup_t_uint256(value) -> cleaned {
            cleaned := value
        }

        function identity(value) -> ret {
            ret := value
        }

        function convert_t_rational_1000_by_1_to_t_uint256(value) -> converted {
            converted := cleanup_t_uint256(identity(cleanup_t_rational_1000_by_1(value)))
        }

        function prepare_store_t_uint256(value) -> ret {
            ret := value
        }

        function update_storage_value_offset_0_t_rational_1000_by_1_to_t_uint256(slot, value_0) {
            let convertedValue_0 := convert_t_rational_1000_by_1_to_t_uint256(value_0)
            sstore(slot, update_byte_slice_32_shift_0(sload(slot), prepare_store_t_uint256(convertedValue_0)))
        }

        function cleanup_t_rational_291_by_1(value) -> cleaned {
            cleaned := value
        }

        function cleanup_t_uint160(value) -> cleaned {
            cleaned := and(value, 0xffffffffffffffffffffffffffffffffffffffff)
        }

        function convert_t_rational_291_by_1_to_t_uint160(value) -> converted {
            converted := cleanup_t_uint160(identity(cleanup_t_rational_291_by_1(value)))
        }

        function convert_t_rational_291_by_1_to_t_address(value) -> converted {
            converted := convert_t_rational_291_by_1_to_t_uint160(value)
        }

        function update_byte_slice_20_shift_0(value, toInsert) -> result {
            let mask := 0xffffffffffffffffffffffffffffffffffffffff
            toInsert := shift_left_0(toInsert)
            value := and(value, not(mask))
            result := or(value, and(toInsert, mask))
        }

        function convert_t_uint160_to_t_uint160(value) -> converted {
            converted := cleanup_t_uint160(identity(cleanup_t_uint160(value)))
        }

        function convert_t_uint160_to_t_address(value) -> converted {
            converted := convert_t_uint160_to_t_uint160(value)
        }

        function convert_t_address_to_t_address(value) -> converted {
            converted := convert_t_uint160_to_t_address(value)
        }

        function prepare_store_t_address(value) -> ret {
            ret := value
        }

        function update_storage_value_offset_0_t_address_to_t_address(slot, value_0) {
            let convertedValue_0 := convert_t_address_to_t_address(value_0)
            sstore(slot, update_byte_slice_20_shift_0(sload(slot), prepare_store_t_address(convertedValue_0)))
        }

        /// @src 0:3189:3981  "contract ErrorHandling {..."
        function constructor_ErrorHandling_444() {

            /// @src 0:3189:3981  "contract ErrorHandling {..."

            /// @src 0:3402:3406  "1000"
            let expr_376 := 0x03e8
            update_storage_value_offset_0_t_rational_1000_by_1_to_t_uint256(0x00, expr_376)
            /// @src 0:3449:3454  "0x123"
            let expr_381 := 0x0123
            /// @src 0:3441:3455  "address(0x123)"
            let expr_382 := convert_t_rational_291_by_1_to_t_address(expr_381)
            update_storage_value_offset_0_t_address_to_t_address(0x01, expr_382)

        }
        /// @src 0:3189:3981  "contract ErrorHandling {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/MainnetComponents.sol"
    object "ErrorHandling_444_deployed" {
        code {
            /// @src 0:3189:3981  "contract ErrorHandling {..."
            mstore(64, memoryguard(128))

            if iszero(lt(calldatasize(), 4))
            {
                let selector := shift_right_224_unsigned(calldataload(0))
                switch selector

                case 0x00b3615d
                {
                    // testCustomError(string)

                    external_fun_testCustomError_443()
                }

                case 0x20987767
                {
                    // testRevert(uint256)

                    external_fun_testRevert_399()
                }

                case 0x246ce3f9
                {
                    // testAssert(uint256)

                    external_fun_testAssert_424()
                }

                case 0x697f3e97
                {
                    // testRequire(address)

                    external_fun_testRequire_412()
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

            function revert_error_1b9f4a0a5773e33b91aa01db23bf8c55fce1411167c872835e7fa00a4f17d46d() {
                revert(0, 0)
            }

            function revert_error_987264b3b1d58a9c7f8255e93e81c77d86d6299019c33110a076957a3e06e2ae() {
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

            function array_allocation_size_t_string_memory_ptr(length) -> size {
                // Make sure we can allocate memory without overflow
                if gt(length, 0xffffffffffffffff) { panic_error_0x41() }

                size := round_up_to_mul_of_32(length)

                // add length slot
                size := add(size, 0x20)

            }

            function copy_calldata_to_memory_with_cleanup(src, dst, length) {

                calldatacopy(dst, src, length)
                mstore(add(dst, length), 0)

            }

            function abi_decode_available_length_t_string_memory_ptr(src, length, end) -> array {
                array := allocate_memory(array_allocation_size_t_string_memory_ptr(length))
                mstore(array, length)
                let dst := add(array, 0x20)
                if gt(add(src, length), end) { revert_error_987264b3b1d58a9c7f8255e93e81c77d86d6299019c33110a076957a3e06e2ae() }
                copy_calldata_to_memory_with_cleanup(src, dst, length)
            }

            // string
            function abi_decode_t_string_memory_ptr(offset, end) -> array {
                if iszero(slt(add(offset, 0x1f), end)) { revert_error_1b9f4a0a5773e33b91aa01db23bf8c55fce1411167c872835e7fa00a4f17d46d() }
                let length := calldataload(offset)
                array := abi_decode_available_length_t_string_memory_ptr(add(offset, 0x20), length, end)
            }

            function abi_decode_tuple_t_string_memory_ptr(headStart, dataEnd) -> value0 {
                if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := calldataload(add(headStart, 0))
                    if gt(offset, 0xffffffffffffffff) { revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() }

                    value0 := abi_decode_t_string_memory_ptr(add(headStart, offset), dataEnd)
                }

            }

            function abi_encode_tuple__to__fromStack(headStart ) -> tail {
                tail := add(headStart, 0)

            }

            function external_fun_testCustomError_443() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_string_memory_ptr(4, calldatasize())
                fun_testCustomError_443(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple__to__fromStack(memPos  )
                return(memPos, sub(memEnd, memPos))

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

            function external_fun_testRevert_399() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                fun_testRevert_399(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple__to__fromStack(memPos  )
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_testAssert_424() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                fun_testAssert_424(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple__to__fromStack(memPos  )
                return(memPos, sub(memEnd, memPos))

            }

            function cleanup_t_uint160(value) -> cleaned {
                cleaned := and(value, 0xffffffffffffffffffffffffffffffffffffffff)
            }

            function cleanup_t_address(value) -> cleaned {
                cleaned := cleanup_t_uint160(value)
            }

            function validator_revert_t_address(value) {
                if iszero(eq(value, cleanup_t_address(value))) { revert(0, 0) }
            }

            function abi_decode_t_address(offset, end) -> value {
                value := calldataload(offset)
                validator_revert_t_address(value)
            }

            function abi_decode_tuple_t_address(headStart, dataEnd) -> value0 {
                if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := 0

                    value0 := abi_decode_t_address(add(headStart, offset), dataEnd)
                }

            }

            function external_fun_testRequire_412() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_address(4, calldatasize())
                fun_testRequire_412(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple__to__fromStack(memPos  )
                return(memPos, sub(memEnd, memPos))

            }

            function revert_error_42b3090547df1d2001c96683413b8cf91c1b902ef5e3cb8d9f6f304cf7446f74() {
                revert(0, 0)
            }

            function convert_array_t_string_memory_ptr_to_t_bytes_memory_ptr(value) -> converted  {
                converted := value

            }

            function array_length_t_bytes_memory_ptr(value) -> length {

                length := mload(value)

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

            /// @ast-id 443
            /// @src 0:3820:3979  "function testCustomError(string memory param) public pure {..."
            function fun_testCustomError_443(var_param_426_mpos) {

                /// @src 0:3898:3903  "param"
                let _1_mpos := var_param_426_mpos
                let expr_431_mpos := _1_mpos
                /// @src 0:3892:3904  "bytes(param)"
                let expr_432_mpos := convert_array_t_string_memory_ptr_to_t_bytes_memory_ptr(expr_431_mpos)
                /// @src 0:3892:3911  "bytes(param).length"
                let expr_433 := array_length_t_bytes_memory_ptr(expr_432_mpos)
                /// @src 0:3915:3916  "0"
                let expr_434 := 0x00
                /// @src 0:3892:3916  "bytes(param).length == 0"
                let expr_435 := eq(cleanup_t_uint256(expr_433), convert_t_rational_0_by_1_to_t_uint256(expr_434))
                /// @src 0:3888:3973  "if (bytes(param).length == 0) {..."
                if expr_435 {
                    /// @src 0:3956:3961  "param"
                    let _2_mpos := var_param_426_mpos
                    let expr_437_mpos := _2_mpos
                    /// @src 0:3939:3962  "InvalidParameter(param)"
                    {

                        let _3 := allocate_unbounded()

                        mstore(_3, 0xaa33ade000000000000000000000000000000000000000000000000000000000)
                        let _4 := abi_encode_tuple_t_string_memory_ptr__to_t_string_memory_ptr__fromStack(add(_3, 4) , expr_437_mpos)
                        revert(_3, sub(_4, _3))
                    }/// @src 0:3888:3973  "if (bytes(param).length == 0) {..."
                }

            }
            /// @src 0:3189:3981  "contract ErrorHandling {..."

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

            function abi_encode_t_uint256_to_t_uint256_fromStack(value, pos) {
                mstore(pos, cleanup_t_uint256(value))
            }

            function abi_encode_tuple_t_uint256_t_uint256__to_t_uint256_t_uint256__fromStack(headStart , value0, value1) -> tail {
                tail := add(headStart, 64)

                abi_encode_t_uint256_to_t_uint256_fromStack(value0,  add(headStart, 0))

                abi_encode_t_uint256_to_t_uint256_fromStack(value1,  add(headStart, 32))

            }

            /// @ast-id 399
            /// @src 0:3462:3616  "function testRevert(uint256 amount) public view {..."
            function fun_testRevert_399(var_amount_385) {

                /// @src 0:3524:3530  "amount"
                let _5 := var_amount_385
                let expr_388 := _5
                /// @src 0:3533:3540  "balance"
                let _6 := read_from_storage_split_offset_0_t_uint256(0x00)
                let expr_389 := _6
                /// @src 0:3524:3540  "amount > balance"
                let expr_390 := gt(cleanup_t_uint256(expr_388), cleanup_t_uint256(expr_389))
                /// @src 0:3520:3610  "if (amount > balance) {..."
                if expr_390 {
                    /// @src 0:3583:3589  "amount"
                    let _7 := var_amount_385
                    let expr_392 := _7
                    /// @src 0:3591:3598  "balance"
                    let _8 := read_from_storage_split_offset_0_t_uint256(0x00)
                    let expr_393 := _8
                    /// @src 0:3563:3599  "InsufficientBalance(amount, balance)"
                    {

                        let _9 := 0

                        mstore(_9, 0xcf47918100000000000000000000000000000000000000000000000000000000)
                        let _10 := abi_encode_tuple_t_uint256_t_uint256__to_t_uint256_t_uint256__fromStack(add(_9, 4) , expr_392, expr_393)
                        revert(_9, sub(_10, _9))
                    }/// @src 0:3520:3610  "if (amount > balance) {..."
                }

            }
            /// @src 0:3189:3981  "contract ErrorHandling {..."

            function panic_error_0x01() {
                mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                mstore(4, 0x01)
                revert(0, 0x24)
            }

            function assert_helper(condition) {
                if iszero(condition) { panic_error_0x01() }
            }

            /// @ast-id 424
            /// @src 0:3741:3814  "function testAssert(uint256 x) public pure {..."
            function fun_testAssert_424(var_x_414) {

                /// @src 0:3801:3802  "x"
                let _11 := var_x_414
                let expr_418 := _11
                /// @src 0:3805:3806  "0"
                let expr_419 := 0x00
                /// @src 0:3801:3806  "x > 0"
                let expr_420 := gt(cleanup_t_uint256(expr_418), convert_t_rational_0_by_1_to_t_uint256(expr_419))
                /// @src 0:3794:3807  "assert(x > 0)"
                assert_helper(expr_420)

            }
            /// @src 0:3189:3981  "contract ErrorHandling {..."

            function cleanup_from_storage_t_address(value) -> cleaned {
                cleaned := and(value, 0xffffffffffffffffffffffffffffffffffffffff)
            }

            function extract_from_storage_value_offset_0_t_address(slot_value) -> value {
                value := cleanup_from_storage_t_address(shift_right_0_unsigned(slot_value))
            }

            function read_from_storage_split_offset_0_t_address(slot) -> value {
                value := extract_from_storage_value_offset_0_t_address(sload(slot))

            }

            function store_literal_in_memory_fac3bac318c0d00994f57b0f2f4c643c313072b71db2302bf4b900309cc50b36(memPtr) {

                mstore(add(memPtr, 0), "Not authorized")

            }

            function abi_encode_t_stringliteral_fac3bac318c0d00994f57b0f2f4c643c313072b71db2302bf4b900309cc50b36_to_t_string_memory_ptr_fromStack(pos) -> end {
                pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 14)
                store_literal_in_memory_fac3bac318c0d00994f57b0f2f4c643c313072b71db2302bf4b900309cc50b36(pos)
                end := add(pos, 32)
            }

            function abi_encode_tuple_t_stringliteral_fac3bac318c0d00994f57b0f2f4c643c313072b71db2302bf4b900309cc50b36__to_t_string_memory_ptr__fromStack(headStart ) -> tail {
                tail := add(headStart, 32)

                mstore(add(headStart, 0), sub(tail, headStart))
                tail := abi_encode_t_stringliteral_fac3bac318c0d00994f57b0f2f4c643c313072b71db2302bf4b900309cc50b36_to_t_string_memory_ptr_fromStack( tail)

            }

            function require_helper_t_stringliteral_fac3bac318c0d00994f57b0f2f4c643c313072b71db2302bf4b900309cc50b36(condition ) {
                if iszero(condition)
                {

                    let memPtr := allocate_unbounded()

                    mstore(memPtr, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                    let end := abi_encode_tuple_t_stringliteral_fac3bac318c0d00994f57b0f2f4c643c313072b71db2302bf4b900309cc50b36__to_t_string_memory_ptr__fromStack(add(memPtr, 4) )
                    revert(memPtr, sub(end, memPtr))
                }
            }

            /// @ast-id 412
            /// @src 0:3622:3735  "function testRequire(address caller) public view {..."
            function fun_testRequire_412(var_caller_401) {

                /// @src 0:3689:3695  "caller"
                let _12 := var_caller_401
                let expr_405 := _12
                /// @src 0:3699:3709  "authorized"
                let _13 := read_from_storage_split_offset_0_t_address(0x01)
                let expr_406 := _13
                /// @src 0:3689:3709  "caller == authorized"
                let expr_407 := eq(cleanup_t_address(expr_405), cleanup_t_address(expr_406))
                /// @src 0:3681:3728  "require(caller == authorized, \"Not authorized\")"
                require_helper_t_stringliteral_fac3bac318c0d00994f57b0f2f4c643c313072b71db2302bf4b900309cc50b36(expr_407)

            }
            /// @src 0:3189:3981  "contract ErrorHandling {..."

        }

        data ".metadata" hex"a2646970667358221220df21cbe48586f8776b57466f5fe96a0f62578f6989a04a9b7084727d43b6f6a064736f6c634300081e0033"
    }

}




/// @use-src 0:"test_validation/fixtures/solidity/MainnetComponents.sol"
object "MathOperations_304" {
    code {
        /// @src 0:1981:2593  "contract MathOperations {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        constructor_MathOperations_304()

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("MathOperations_304_deployed"), datasize("MathOperations_304_deployed"))

        return(_1, datasize("MathOperations_304_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:1981:2593  "contract MathOperations {..."
        function constructor_MathOperations_304() {

            /// @src 0:1981:2593  "contract MathOperations {..."

        }
        /// @src 0:1981:2593  "contract MathOperations {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/MainnetComponents.sol"
    object "MathOperations_304_deployed" {
        code {
            /// @src 0:1981:2593  "contract MathOperations {..."
            mstore(64, memoryguard(128))

            if iszero(lt(calldatasize(), 4))
            {
                let selector := shift_right_224_unsigned(calldataload(0))
                switch selector

                case 0x7c3ffef2
                {
                    // testAdd(uint256,uint256)

                    external_fun_testAdd_242()
                }

                case 0xbd2c7195
                {
                    // testMul(uint256,uint256)

                    external_fun_testMul_272()
                }

                case 0xdb0721d0
                {
                    // testSub(uint256,uint256)

                    external_fun_testSub_257()
                }

                case 0xfe0fb2f1
                {
                    // complexCalculation(uint256,uint256,uint256)

                    external_fun_complexCalculation_303()
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

            function external_fun_testAdd_242() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1 :=  abi_decode_tuple_t_uint256t_uint256(4, calldatasize())
                let ret_0 :=  fun_testAdd_242(param_0, param_1)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_testMul_272() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1 :=  abi_decode_tuple_t_uint256t_uint256(4, calldatasize())
                let ret_0 :=  fun_testMul_272(param_0, param_1)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_testSub_257() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1 :=  abi_decode_tuple_t_uint256t_uint256(4, calldatasize())
                let ret_0 :=  fun_testSub_257(param_0, param_1)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
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

            function external_fun_complexCalculation_303() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1, param_2 :=  abi_decode_tuple_t_uint256t_uint256t_uint256(4, calldatasize())
                let ret_0 :=  fun_complexCalculation_303(param_0, param_1, param_2)
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

            /// @ast-id 242
            /// @src 0:2044:2145  "function testAdd(uint256 a, uint256 b) public pure returns (uint256) {..."
            function fun_testAdd_242(var_a_229, var_b_231) -> var__234 {
                /// @src 0:2104:2111  "uint256"
                let zero_t_uint256_1 := zero_value_for_split_t_uint256()
                var__234 := zero_t_uint256_1

                /// @src 0:2130:2131  "a"
                let _2 := var_a_229
                let expr_236 := _2
                /// @src 0:2130:2135  "a.add"
                let expr_237_self := expr_236
                /// @src 0:2136:2137  "b"
                let _3 := var_b_231
                let expr_238 := _3
                /// @src 0:2130:2138  "a.add(b)"
                let expr_239 := fun_add_48(expr_237_self, expr_238)
                /// @src 0:2123:2138  "return a.add(b)"
                var__234 := expr_239
                leave

            }
            /// @src 0:1981:2593  "contract MathOperations {..."

            /// @ast-id 272
            /// @src 0:2258:2359  "function testMul(uint256 a, uint256 b) public pure returns (uint256) {..."
            function fun_testMul_272(var_a_259, var_b_261) -> var__264 {
                /// @src 0:2318:2325  "uint256"
                let zero_t_uint256_4 := zero_value_for_split_t_uint256()
                var__264 := zero_t_uint256_4

                /// @src 0:2344:2345  "a"
                let _5 := var_a_259
                let expr_266 := _5
                /// @src 0:2344:2349  "a.mul"
                let expr_267_self := expr_266
                /// @src 0:2350:2351  "b"
                let _6 := var_b_261
                let expr_268 := _6
                /// @src 0:2344:2352  "a.mul(b)"
                let expr_269 := fun_mul_103(expr_267_self, expr_268)
                /// @src 0:2337:2352  "return a.mul(b)"
                var__264 := expr_269
                leave

            }
            /// @src 0:1981:2593  "contract MathOperations {..."

            /// @ast-id 257
            /// @src 0:2151:2252  "function testSub(uint256 a, uint256 b) public pure returns (uint256) {..."
            function fun_testSub_257(var_a_244, var_b_246) -> var__249 {
                /// @src 0:2211:2218  "uint256"
                let zero_t_uint256_7 := zero_value_for_split_t_uint256()
                var__249 := zero_t_uint256_7

                /// @src 0:2237:2238  "a"
                let _8 := var_a_244
                let expr_251 := _8
                /// @src 0:2237:2242  "a.sub"
                let expr_252_self := expr_251
                /// @src 0:2243:2244  "b"
                let _9 := var_b_246
                let expr_253 := _9
                /// @src 0:2237:2245  "a.sub(b)"
                let expr_254 := fun_sub_69(expr_252_self, expr_253)
                /// @src 0:2230:2245  "return a.sub(b)"
                var__249 := expr_254
                leave

            }
            /// @src 0:1981:2593  "contract MathOperations {..."

            /// @ast-id 303
            /// @src 0:2365:2591  "function complexCalculation(uint256 x, uint256 y, uint256 z) public pure returns (uint256) {..."
            function fun_complexCalculation_303(var_x_274, var_y_276, var_z_278) -> var__281 {
                /// @src 0:2447:2454  "uint256"
                let zero_t_uint256_10 := zero_value_for_split_t_uint256()
                var__281 := zero_t_uint256_10

                /// @src 0:2507:2508  "x"
                let _11 := var_x_274
                let expr_285 := _11
                /// @src 0:2507:2512  "x.add"
                let expr_286_self := expr_285
                /// @src 0:2513:2514  "y"
                let _12 := var_y_276
                let expr_287 := _12
                /// @src 0:2507:2515  "x.add(y)"
                let expr_288 := fun_add_48(expr_286_self, expr_287)
                /// @src 0:2493:2515  "uint256 sum = x.add(y)"
                let var_sum_284 := expr_288
                /// @src 0:2543:2546  "sum"
                let _13 := var_sum_284
                let expr_292 := _13
                /// @src 0:2543:2550  "sum.mul"
                let expr_293_self := expr_292
                /// @src 0:2551:2552  "z"
                let _14 := var_z_278
                let expr_294 := _14
                /// @src 0:2543:2553  "sum.mul(z)"
                let expr_295 := fun_mul_103(expr_293_self, expr_294)
                /// @src 0:2525:2553  "uint256 product = sum.mul(z)"
                let var_product_291 := expr_295
                /// @src 0:2570:2577  "product"
                let _15 := var_product_291
                let expr_297 := _15
                /// @src 0:2570:2581  "product.sub"
                let expr_298_self := expr_297
                /// @src 0:2582:2583  "y"
                let _16 := var_y_276
                let expr_299 := _16
                /// @src 0:2570:2584  "product.sub(y)"
                let expr_300 := fun_sub_69(expr_298_self, expr_299)
                /// @src 0:2563:2584  "return product.sub(y)"
                var__281 := expr_300
                leave

            }
            /// @src 0:1981:2593  "contract MathOperations {..."

            function panic_error_0x11() {
                mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                mstore(4, 0x11)
                revert(0, 0x24)
            }

            function checked_add_t_uint256(x, y) -> sum {
                x := cleanup_t_uint256(x)
                y := cleanup_t_uint256(y)
                sum := add(x, y)

                if gt(x, sum) { panic_error_0x11() }

            }

            function array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, length) -> updated_pos {
                mstore(pos, length)
                updated_pos := add(pos, 0x20)
            }

            function store_literal_in_memory_30cc447bcc13b3e22b45cef0dd9b0b514842d836dd9b6eb384e20dedfb47723a(memPtr) {

                mstore(add(memPtr, 0), "SafeMath: addition overflow")

            }

            function abi_encode_t_stringliteral_30cc447bcc13b3e22b45cef0dd9b0b514842d836dd9b6eb384e20dedfb47723a_to_t_string_memory_ptr_fromStack(pos) -> end {
                pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 27)
                store_literal_in_memory_30cc447bcc13b3e22b45cef0dd9b0b514842d836dd9b6eb384e20dedfb47723a(pos)
                end := add(pos, 32)
            }

            function abi_encode_tuple_t_stringliteral_30cc447bcc13b3e22b45cef0dd9b0b514842d836dd9b6eb384e20dedfb47723a__to_t_string_memory_ptr__fromStack(headStart ) -> tail {
                tail := add(headStart, 32)

                mstore(add(headStart, 0), sub(tail, headStart))
                tail := abi_encode_t_stringliteral_30cc447bcc13b3e22b45cef0dd9b0b514842d836dd9b6eb384e20dedfb47723a_to_t_string_memory_ptr_fromStack( tail)

            }

            function require_helper_t_stringliteral_30cc447bcc13b3e22b45cef0dd9b0b514842d836dd9b6eb384e20dedfb47723a(condition ) {
                if iszero(condition)
                {

                    let memPtr := allocate_unbounded()

                    mstore(memPtr, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                    let end := abi_encode_tuple_t_stringliteral_30cc447bcc13b3e22b45cef0dd9b0b514842d836dd9b6eb384e20dedfb47723a__to_t_string_memory_ptr__fromStack(add(memPtr, 4) )
                    revert(memPtr, sub(end, memPtr))
                }
            }

            /// @ast-id 48
            /// @src 0:372:547  "function add(uint256 a, uint256 b) internal pure returns (uint256) {..."
            function fun_add_48(var_a_25, var_b_27) -> var__30 {
                /// @src 0:430:437  "uint256"
                let zero_t_uint256_17 := zero_value_for_split_t_uint256()
                var__30 := zero_t_uint256_17

                /// @src 0:461:462  "a"
                let _18 := var_a_25
                let expr_34 := _18
                /// @src 0:465:466  "b"
                let _19 := var_b_27
                let expr_35 := _19
                /// @src 0:461:466  "a + b"
                let expr_36 := checked_add_t_uint256(expr_34, expr_35)

                /// @src 0:449:466  "uint256 c = a + b"
                let var_c_33 := expr_36
                /// @src 0:484:485  "c"
                let _20 := var_c_33
                let expr_39 := _20
                /// @src 0:489:490  "a"
                let _21 := var_a_25
                let expr_40 := _21
                /// @src 0:484:490  "c >= a"
                let expr_41 := iszero(lt(cleanup_t_uint256(expr_39), cleanup_t_uint256(expr_40)))
                /// @src 0:476:522  "require(c >= a, \"SafeMath: addition overflow\")"
                require_helper_t_stringliteral_30cc447bcc13b3e22b45cef0dd9b0b514842d836dd9b6eb384e20dedfb47723a(expr_41)
                /// @src 0:539:540  "c"
                let _22 := var_c_33
                let expr_45 := _22
                /// @src 0:532:540  "return c"
                var__30 := expr_45
                leave

            }
            /// @src 0:1981:2593  "contract MathOperations {..."

            function cleanup_t_rational_0_by_1(value) -> cleaned {
                cleaned := value
            }

            function identity(value) -> ret {
                ret := value
            }

            function convert_t_rational_0_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_0_by_1(value)))
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

            function store_literal_in_memory_9113bb53c2876a3805b2c9242029423fc540a728243ce887ab24c82cf119fba3(memPtr) {

                mstore(add(memPtr, 0), "SafeMath: multiplication overflo")

                mstore(add(memPtr, 32), "w")

            }

            function abi_encode_t_stringliteral_9113bb53c2876a3805b2c9242029423fc540a728243ce887ab24c82cf119fba3_to_t_string_memory_ptr_fromStack(pos) -> end {
                pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 33)
                store_literal_in_memory_9113bb53c2876a3805b2c9242029423fc540a728243ce887ab24c82cf119fba3(pos)
                end := add(pos, 64)
            }

            function abi_encode_tuple_t_stringliteral_9113bb53c2876a3805b2c9242029423fc540a728243ce887ab24c82cf119fba3__to_t_string_memory_ptr__fromStack(headStart ) -> tail {
                tail := add(headStart, 32)

                mstore(add(headStart, 0), sub(tail, headStart))
                tail := abi_encode_t_stringliteral_9113bb53c2876a3805b2c9242029423fc540a728243ce887ab24c82cf119fba3_to_t_string_memory_ptr_fromStack( tail)

            }

            function require_helper_t_stringliteral_9113bb53c2876a3805b2c9242029423fc540a728243ce887ab24c82cf119fba3(condition ) {
                if iszero(condition)
                {

                    let memPtr := allocate_unbounded()

                    mstore(memPtr, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                    let end := abi_encode_tuple_t_stringliteral_9113bb53c2876a3805b2c9242029423fc540a728243ce887ab24c82cf119fba3__to_t_string_memory_ptr__fromStack(add(memPtr, 4) )
                    revert(memPtr, sub(end, memPtr))
                }
            }

            /// @ast-id 103
            /// @src 0:714:953  "function mul(uint256 a, uint256 b) internal pure returns (uint256) {..."
            function fun_mul_103(var_a_71, var_b_73) -> var__76 {
                /// @src 0:772:779  "uint256"
                let zero_t_uint256_23 := zero_value_for_split_t_uint256()
                var__76 := zero_t_uint256_23

                /// @src 0:795:796  "a"
                let _24 := var_a_71
                let expr_78 := _24
                /// @src 0:800:801  "0"
                let expr_79 := 0x00
                /// @src 0:795:801  "a == 0"
                let expr_80 := eq(cleanup_t_uint256(expr_78), convert_t_rational_0_by_1_to_t_uint256(expr_79))
                /// @src 0:791:836  "if (a == 0) {..."
                if expr_80 {
                    /// @src 0:824:825  "0"
                    let expr_81 := 0x00
                    /// @src 0:817:825  "return 0"
                    var__76 := convert_t_rational_0_by_1_to_t_uint256(expr_81)
                    leave
                    /// @src 0:791:836  "if (a == 0) {..."
                }
                /// @src 0:857:858  "a"
                let _25 := var_a_71
                let expr_87 := _25
                /// @src 0:861:862  "b"
                let _26 := var_b_73
                let expr_88 := _26
                /// @src 0:857:862  "a * b"
                let expr_89 := checked_mul_t_uint256(expr_87, expr_88)

                /// @src 0:845:862  "uint256 c = a * b"
                let var_c_86 := expr_89
                /// @src 0:880:881  "c"
                let _27 := var_c_86
                let expr_92 := _27
                /// @src 0:884:885  "a"
                let _28 := var_a_71
                let expr_93 := _28
                /// @src 0:880:885  "c / a"
                let expr_94 := checked_div_t_uint256(expr_92, expr_93)

                /// @src 0:889:890  "b"
                let _29 := var_b_73
                let expr_95 := _29
                /// @src 0:880:890  "c / a == b"
                let expr_96 := eq(cleanup_t_uint256(expr_94), cleanup_t_uint256(expr_95))
                /// @src 0:872:928  "require(c / a == b, \"SafeMath: multiplication overflow\")"
                require_helper_t_stringliteral_9113bb53c2876a3805b2c9242029423fc540a728243ce887ab24c82cf119fba3(expr_96)
                /// @src 0:945:946  "c"
                let _30 := var_c_86
                let expr_100 := _30
                /// @src 0:938:946  "return c"
                var__76 := expr_100
                leave

            }
            /// @src 0:1981:2593  "contract MathOperations {..."

            function store_literal_in_memory_50b058e9b5320e58880d88223c9801cd9eecdcf90323d5c2318bc1b6b916e862(memPtr) {

                mstore(add(memPtr, 0), "SafeMath: subtraction overflow")

            }

            function abi_encode_t_stringliteral_50b058e9b5320e58880d88223c9801cd9eecdcf90323d5c2318bc1b6b916e862_to_t_string_memory_ptr_fromStack(pos) -> end {
                pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 30)
                store_literal_in_memory_50b058e9b5320e58880d88223c9801cd9eecdcf90323d5c2318bc1b6b916e862(pos)
                end := add(pos, 32)
            }

            function abi_encode_tuple_t_stringliteral_50b058e9b5320e58880d88223c9801cd9eecdcf90323d5c2318bc1b6b916e862__to_t_string_memory_ptr__fromStack(headStart ) -> tail {
                tail := add(headStart, 32)

                mstore(add(headStart, 0), sub(tail, headStart))
                tail := abi_encode_t_stringliteral_50b058e9b5320e58880d88223c9801cd9eecdcf90323d5c2318bc1b6b916e862_to_t_string_memory_ptr_fromStack( tail)

            }

            function require_helper_t_stringliteral_50b058e9b5320e58880d88223c9801cd9eecdcf90323d5c2318bc1b6b916e862(condition ) {
                if iszero(condition)
                {

                    let memPtr := allocate_unbounded()

                    mstore(memPtr, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                    let end := abi_encode_tuple_t_stringliteral_50b058e9b5320e58880d88223c9801cd9eecdcf90323d5c2318bc1b6b916e862__to_t_string_memory_ptr__fromStack(add(memPtr, 4) )
                    revert(memPtr, sub(end, memPtr))
                }
            }

            function checked_sub_t_uint256(x, y) -> diff {
                x := cleanup_t_uint256(x)
                y := cleanup_t_uint256(y)
                diff := sub(x, y)

                if gt(diff, x) { panic_error_0x11() }

            }

            /// @ast-id 69
            /// @src 0:553:708  "function sub(uint256 a, uint256 b) internal pure returns (uint256) {..."
            function fun_sub_69(var_a_50, var_b_52) -> var__55 {
                /// @src 0:611:618  "uint256"
                let zero_t_uint256_31 := zero_value_for_split_t_uint256()
                var__55 := zero_t_uint256_31

                /// @src 0:638:639  "b"
                let _32 := var_b_52
                let expr_58 := _32
                /// @src 0:643:644  "a"
                let _33 := var_a_50
                let expr_59 := _33
                /// @src 0:638:644  "b <= a"
                let expr_60 := iszero(gt(cleanup_t_uint256(expr_58), cleanup_t_uint256(expr_59)))
                /// @src 0:630:679  "require(b <= a, \"SafeMath: subtraction overflow\")"
                require_helper_t_stringliteral_50b058e9b5320e58880d88223c9801cd9eecdcf90323d5c2318bc1b6b916e862(expr_60)
                /// @src 0:696:697  "a"
                let _34 := var_a_50
                let expr_64 := _34
                /// @src 0:700:701  "b"
                let _35 := var_b_52
                let expr_65 := _35
                /// @src 0:696:701  "a - b"
                let expr_66 := checked_sub_t_uint256(expr_64, expr_65)

                /// @src 0:689:701  "return a - b"
                var__55 := expr_66
                leave

            }
            /// @src 0:1981:2593  "contract MathOperations {..."

        }

        data ".metadata" hex"a2646970667358221220e9d6346d9d1f96861f2a287ba128c22cef1bc7f1cf20e6b832eda176c505d05764736f6c634300081e0033"
    }

}




/// @use-src 0:"test_validation/fixtures/solidity/MainnetComponents.sol"
object "MemoryPatterns_545" {
    code {
        /// @src 0:3983:4664  "contract MemoryPatterns {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        constructor_MemoryPatterns_545()

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("MemoryPatterns_545_deployed"), datasize("MemoryPatterns_545_deployed"))

        return(_1, datasize("MemoryPatterns_545_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:3983:4664  "contract MemoryPatterns {..."
        function constructor_MemoryPatterns_545() {

            /// @src 0:3983:4664  "contract MemoryPatterns {..."

        }
        /// @src 0:3983:4664  "contract MemoryPatterns {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/MainnetComponents.sol"
    object "MemoryPatterns_545_deployed" {
        code {
            /// @src 0:3983:4664  "contract MemoryPatterns {..."
            mstore(64, memoryguard(128))

            if iszero(lt(calldatasize(), 4))
            {
                let selector := shift_right_224_unsigned(calldataload(0))
                switch selector

                case 0x266001d3
                {
                    // concatenate(string,string)

                    external_fun_concatenate_544()
                }

                case 0xe23b8e45
                {
                    // allocateArray(uint256)

                    external_fun_allocateArray_486()
                }

                case 0xe74df2c5
                {
                    // copyBytes(bytes)

                    external_fun_copyBytes_525()
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

            function revert_error_1b9f4a0a5773e33b91aa01db23bf8c55fce1411167c872835e7fa00a4f17d46d() {
                revert(0, 0)
            }

            function revert_error_987264b3b1d58a9c7f8255e93e81c77d86d6299019c33110a076957a3e06e2ae() {
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

            function array_allocation_size_t_string_memory_ptr(length) -> size {
                // Make sure we can allocate memory without overflow
                if gt(length, 0xffffffffffffffff) { panic_error_0x41() }

                size := round_up_to_mul_of_32(length)

                // add length slot
                size := add(size, 0x20)

            }

            function copy_calldata_to_memory_with_cleanup(src, dst, length) {

                calldatacopy(dst, src, length)
                mstore(add(dst, length), 0)

            }

            function abi_decode_available_length_t_string_memory_ptr(src, length, end) -> array {
                array := allocate_memory(array_allocation_size_t_string_memory_ptr(length))
                mstore(array, length)
                let dst := add(array, 0x20)
                if gt(add(src, length), end) { revert_error_987264b3b1d58a9c7f8255e93e81c77d86d6299019c33110a076957a3e06e2ae() }
                copy_calldata_to_memory_with_cleanup(src, dst, length)
            }

            // string
            function abi_decode_t_string_memory_ptr(offset, end) -> array {
                if iszero(slt(add(offset, 0x1f), end)) { revert_error_1b9f4a0a5773e33b91aa01db23bf8c55fce1411167c872835e7fa00a4f17d46d() }
                let length := calldataload(offset)
                array := abi_decode_available_length_t_string_memory_ptr(add(offset, 0x20), length, end)
            }

            function abi_decode_tuple_t_string_memory_ptrt_string_memory_ptr(headStart, dataEnd) -> value0, value1 {
                if slt(sub(dataEnd, headStart), 64) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := calldataload(add(headStart, 0))
                    if gt(offset, 0xffffffffffffffff) { revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() }

                    value0 := abi_decode_t_string_memory_ptr(add(headStart, offset), dataEnd)
                }

                {

                    let offset := calldataload(add(headStart, 32))
                    if gt(offset, 0xffffffffffffffff) { revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() }

                    value1 := abi_decode_t_string_memory_ptr(add(headStart, offset), dataEnd)
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

            function external_fun_concatenate_544() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1 :=  abi_decode_tuple_t_string_memory_ptrt_string_memory_ptr(4, calldatasize())
                let ret_0 :=  fun_concatenate_544(param_0, param_1)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_string_memory_ptr__to_t_string_memory_ptr__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

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

            function array_length_t_array$_t_uint256_$dyn_memory_ptr(value) -> length {

                length := mload(value)

            }

            function array_storeLengthForEncoding_t_array$_t_uint256_$dyn_memory_ptr_fromStack(pos, length) -> updated_pos {
                mstore(pos, length)
                updated_pos := add(pos, 0x20)
            }

            function array_dataslot_t_array$_t_uint256_$dyn_memory_ptr(ptr) -> data {
                data := ptr

                data := add(ptr, 0x20)

            }

            function abi_encode_t_uint256_to_t_uint256(value, pos) {
                mstore(pos, cleanup_t_uint256(value))
            }

            function abi_encodeUpdatedPos_t_uint256_to_t_uint256(value0, pos) -> updatedPos {
                abi_encode_t_uint256_to_t_uint256(value0, pos)
                updatedPos := add(pos, 0x20)
            }

            function array_nextElement_t_array$_t_uint256_$dyn_memory_ptr(ptr) -> next {
                next := add(ptr, 0x20)
            }

            // uint256[] -> uint256[]
            function abi_encode_t_array$_t_uint256_$dyn_memory_ptr_to_t_array$_t_uint256_$dyn_memory_ptr_fromStack(value, pos)  -> end  {
                let length := array_length_t_array$_t_uint256_$dyn_memory_ptr(value)
                pos := array_storeLengthForEncoding_t_array$_t_uint256_$dyn_memory_ptr_fromStack(pos, length)
                let baseRef := array_dataslot_t_array$_t_uint256_$dyn_memory_ptr(value)
                let srcPtr := baseRef
                for { let i := 0 } lt(i, length) { i := add(i, 1) }
                {
                    let elementValue0 := mload(srcPtr)
                    pos := abi_encodeUpdatedPos_t_uint256_to_t_uint256(elementValue0, pos)
                    srcPtr := array_nextElement_t_array$_t_uint256_$dyn_memory_ptr(srcPtr)
                }
                end := pos
            }

            function abi_encode_tuple_t_array$_t_uint256_$dyn_memory_ptr__to_t_array$_t_uint256_$dyn_memory_ptr__fromStack(headStart , value0) -> tail {
                tail := add(headStart, 32)

                mstore(add(headStart, 0), sub(tail, headStart))
                tail := abi_encode_t_array$_t_uint256_$dyn_memory_ptr_to_t_array$_t_uint256_$dyn_memory_ptr_fromStack(value0,  tail)

            }

            function external_fun_allocateArray_486() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                let ret_0 :=  fun_allocateArray_486(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_array$_t_uint256_$dyn_memory_ptr__to_t_array$_t_uint256_$dyn_memory_ptr__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function array_allocation_size_t_bytes_memory_ptr(length) -> size {
                // Make sure we can allocate memory without overflow
                if gt(length, 0xffffffffffffffff) { panic_error_0x41() }

                size := round_up_to_mul_of_32(length)

                // add length slot
                size := add(size, 0x20)

            }

            function abi_decode_available_length_t_bytes_memory_ptr(src, length, end) -> array {
                array := allocate_memory(array_allocation_size_t_bytes_memory_ptr(length))
                mstore(array, length)
                let dst := add(array, 0x20)
                if gt(add(src, length), end) { revert_error_987264b3b1d58a9c7f8255e93e81c77d86d6299019c33110a076957a3e06e2ae() }
                copy_calldata_to_memory_with_cleanup(src, dst, length)
            }

            // bytes
            function abi_decode_t_bytes_memory_ptr(offset, end) -> array {
                if iszero(slt(add(offset, 0x1f), end)) { revert_error_1b9f4a0a5773e33b91aa01db23bf8c55fce1411167c872835e7fa00a4f17d46d() }
                let length := calldataload(offset)
                array := abi_decode_available_length_t_bytes_memory_ptr(add(offset, 0x20), length, end)
            }

            function abi_decode_tuple_t_bytes_memory_ptr(headStart, dataEnd) -> value0 {
                if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := calldataload(add(headStart, 0))
                    if gt(offset, 0xffffffffffffffff) { revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() }

                    value0 := abi_decode_t_bytes_memory_ptr(add(headStart, offset), dataEnd)
                }

            }

            function array_length_t_bytes_memory_ptr(value) -> length {

                length := mload(value)

            }

            function array_storeLengthForEncoding_t_bytes_memory_ptr_fromStack(pos, length) -> updated_pos {
                mstore(pos, length)
                updated_pos := add(pos, 0x20)
            }

            function abi_encode_t_bytes_memory_ptr_to_t_bytes_memory_ptr_fromStack(value, pos) -> end {
                let length := array_length_t_bytes_memory_ptr(value)
                pos := array_storeLengthForEncoding_t_bytes_memory_ptr_fromStack(pos, length)
                copy_memory_to_memory_with_cleanup(add(value, 0x20), pos, length)
                end := add(pos, round_up_to_mul_of_32(length))
            }

            function abi_encode_tuple_t_bytes_memory_ptr__to_t_bytes_memory_ptr__fromStack(headStart , value0) -> tail {
                tail := add(headStart, 32)

                mstore(add(headStart, 0), sub(tail, headStart))
                tail := abi_encode_t_bytes_memory_ptr_to_t_bytes_memory_ptr_fromStack(value0,  tail)

            }

            function external_fun_copyBytes_525() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_bytes_memory_ptr(4, calldatasize())
                let ret_0 :=  fun_copyBytes_525(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_bytes_memory_ptr__to_t_bytes_memory_ptr__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function revert_error_42b3090547df1d2001c96683413b8cf91c1b902ef5e3cb8d9f6f304cf7446f74() {
                revert(0, 0)
            }

            function zero_value_for_split_t_string_memory_ptr() -> ret {
                ret := 96
            }

            function array_storeLengthForEncoding_t_string_memory_ptr_nonPadded_inplace_fromStack(pos, length) -> updated_pos {
                updated_pos := pos
            }

            function abi_encode_t_string_memory_ptr_to_t_string_memory_ptr_nonPadded_inplace_fromStack(value, pos) -> end {
                let length := array_length_t_string_memory_ptr(value)
                pos := array_storeLengthForEncoding_t_string_memory_ptr_nonPadded_inplace_fromStack(pos, length)
                copy_memory_to_memory_with_cleanup(add(value, 0x20), pos, length)
                end := add(pos, length)
            }

            function abi_encode_tuple_packed_t_string_memory_ptr_t_string_memory_ptr__to_t_string_memory_ptr_t_string_memory_ptr__nonPadded_inplace_fromStack(pos , value0, value1) -> end {

                pos := abi_encode_t_string_memory_ptr_to_t_string_memory_ptr_nonPadded_inplace_fromStack(value0,  pos)

                pos := abi_encode_t_string_memory_ptr_to_t_string_memory_ptr_nonPadded_inplace_fromStack(value1,  pos)

                end := pos
            }

            function convert_array_t_bytes_memory_ptr_to_t_string_memory_ptr(value) -> converted  {
                converted := value

            }

            /// @ast-id 544
            /// @src 0:4517:4662  "function concatenate(string memory a, string memory b) public pure returns (string memory) {..."
            function fun_concatenate_544(var_a_527_mpos, var_b_529_mpos) -> var__532_mpos {
                /// @src 0:4593:4606  "string memory"
                let zero_t_string_memory_ptr_1_mpos := zero_value_for_split_t_string_memory_ptr()
                var__532_mpos := zero_t_string_memory_ptr_1_mpos

                /// @src 0:4649:4650  "a"
                let _2_mpos := var_a_527_mpos
                let expr_538_mpos := _2_mpos
                /// @src 0:4652:4653  "b"
                let _3_mpos := var_b_529_mpos
                let expr_539_mpos := _3_mpos
                /// @src 0:4632:4654  "abi.encodePacked(a, b)"

                let expr_540_mpos := allocate_unbounded()
                let _4 := add(expr_540_mpos, 0x20)

                let _5 := abi_encode_tuple_packed_t_string_memory_ptr_t_string_memory_ptr__to_t_string_memory_ptr_t_string_memory_ptr__nonPadded_inplace_fromStack(_4, expr_538_mpos, expr_539_mpos)
                mstore(expr_540_mpos, sub(_5, add(expr_540_mpos, 0x20)))
                finalize_allocation(expr_540_mpos, sub(_5, expr_540_mpos))
                /// @src 0:4625:4655  "string(abi.encodePacked(a, b))"
                let expr_541_mpos := convert_array_t_bytes_memory_ptr_to_t_string_memory_ptr(expr_540_mpos)
                /// @src 0:4618:4655  "return string(abi.encodePacked(a, b))"
                var__532_mpos := expr_541_mpos
                leave

            }
            /// @src 0:3983:4664  "contract MemoryPatterns {..."

            function zero_value_for_split_t_array$_t_uint256_$dyn_memory_ptr() -> ret {
                ret := 96
            }

            function array_allocation_size_t_array$_t_uint256_$dyn_memory_ptr(length) -> size {
                // Make sure we can allocate memory without overflow
                if gt(length, 0xffffffffffffffff) { panic_error_0x41() }

                size := mul(length, 0x20)

                // add length slot
                size := add(size, 0x20)

            }

            function allocate_memory_array_t_array$_t_uint256_$dyn_memory_ptr(length) -> memPtr {
                let allocSize := array_allocation_size_t_array$_t_uint256_$dyn_memory_ptr(length)
                memPtr := allocate_memory(allocSize)

                mstore(memPtr, length)

            }

            function zero_memory_chunk_t_uint256(dataStart, dataSizeInBytes) {
                calldatacopy(dataStart, calldatasize(), dataSizeInBytes)
            }

            function allocate_and_zero_memory_array_t_array$_t_uint256_$dyn_memory_ptr(length) -> memPtr {
                memPtr := allocate_memory_array_t_array$_t_uint256_$dyn_memory_ptr(length)
                let dataStart := memPtr
                let dataSize := array_allocation_size_t_array$_t_uint256_$dyn_memory_ptr(length)

                dataStart := add(dataStart, 32)
                dataSize := sub(dataSize, 32)

                zero_memory_chunk_t_uint256(dataStart, dataSize)
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

            function increment_wrapping_t_uint256(value) -> ret {
                ret := cleanup_t_uint256(add(value, 1))
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

            function write_to_memory_t_uint256(memPtr, value) {
                mstore(memPtr, cleanup_t_uint256(value))
            }

            /// @ast-id 486
            /// @src 0:4013:4251  "function allocateArray(uint256 size) public pure returns (uint256[] memory) {..."
            function fun_allocateArray_486(var_size_446) -> var__450_mpos {
                /// @src 0:4071:4087  "uint256[] memory"
                let zero_t_array$_t_uint256_$dyn_memory_ptr_6_mpos := zero_value_for_split_t_array$_t_uint256_$dyn_memory_ptr()
                var__450_mpos := zero_t_array$_t_uint256_$dyn_memory_ptr_6_mpos

                /// @src 0:4136:4140  "size"
                let _7 := var_size_446
                let expr_460 := _7
                /// @src 0:4122:4141  "new uint256[](size)"
                let expr_461_mpos := allocate_and_zero_memory_array_t_array$_t_uint256_$dyn_memory_ptr(expr_460)
                /// @src 0:4099:4141  "uint256[] memory arr = new uint256[](size)"
                let var_arr_456_mpos := expr_461_mpos
                /// @src 0:4151:4225  "for (uint256 i = 0; i < size; i++) {..."
                for {
                    /// @src 0:4168:4169  "0"
                    let expr_465 := 0x00
                    /// @src 0:4156:4169  "uint256 i = 0"
                    let var_i_464 := convert_t_rational_0_by_1_to_t_uint256(expr_465)
                    } 1 {
                    /// @src 0:4181:4184  "i++"
                    let _9 := var_i_464
                    let _8 := increment_wrapping_t_uint256(_9)
                    var_i_464 := _8
                    let expr_471 := _9
                }
                {
                    /// @src 0:4171:4172  "i"
                    let _10 := var_i_464
                    let expr_467 := _10
                    /// @src 0:4175:4179  "size"
                    let _11 := var_size_446
                    let expr_468 := _11
                    /// @src 0:4171:4179  "i < size"
                    let expr_469 := lt(cleanup_t_uint256(expr_467), cleanup_t_uint256(expr_468))
                    if iszero(expr_469) { break }
                    /// @src 0:4209:4210  "i"
                    let _12 := var_i_464
                    let expr_476 := _12
                    /// @src 0:4213:4214  "2"
                    let expr_477 := 0x02
                    /// @src 0:4209:4214  "i * 2"
                    let expr_478 := checked_mul_t_uint256(expr_476, convert_t_rational_2_by_1_to_t_uint256(expr_477))

                    /// @src 0:4200:4203  "arr"
                    let _13_mpos := var_arr_456_mpos
                    let expr_473_mpos := _13_mpos
                    /// @src 0:4204:4205  "i"
                    let _14 := var_i_464
                    let expr_474 := _14
                    /// @src 0:4200:4214  "arr[i] = i * 2"
                    let _15 := expr_478
                    write_to_memory_t_uint256(memory_array_index_access_t_array$_t_uint256_$dyn_memory_ptr(expr_473_mpos, expr_474), _15)
                    let expr_479 := expr_478
                }
                /// @src 0:4241:4244  "arr"
                let _16_mpos := var_arr_456_mpos
                let expr_483_mpos := _16_mpos
                /// @src 0:4234:4244  "return arr"
                var__450_mpos := expr_483_mpos
                leave

            }
            /// @src 0:3983:4664  "contract MemoryPatterns {..."

            function zero_value_for_split_t_bytes_memory_ptr() -> ret {
                ret := 96
            }

            function allocate_memory_array_t_bytes_memory_ptr(length) -> memPtr {
                let allocSize := array_allocation_size_t_bytes_memory_ptr(length)
                memPtr := allocate_memory(allocSize)

                mstore(memPtr, length)

            }

            function zero_memory_chunk_t_bytes1(dataStart, dataSizeInBytes) {
                calldatacopy(dataStart, calldatasize(), dataSizeInBytes)
            }

            function allocate_and_zero_memory_array_t_bytes_memory_ptr(length) -> memPtr {
                memPtr := allocate_memory_array_t_bytes_memory_ptr(length)
                let dataStart := memPtr
                let dataSize := array_allocation_size_t_bytes_memory_ptr(length)

                dataStart := add(dataStart, 32)
                dataSize := sub(dataSize, 32)

                zero_memory_chunk_t_bytes1(dataStart, dataSize)
            }

            function memory_array_index_access_t_bytes_memory_ptr(baseRef, index) -> addr {
                if iszero(lt(index, array_length_t_bytes_memory_ptr(baseRef))) {
                    panic_error_0x32()
                }

                let offset := mul(index, 1)

                offset := add(offset, 32)

                addr := add(baseRef, offset)
            }

            function cleanup_t_bytes1(value) -> cleaned {
                cleaned := and(value, 0xff00000000000000000000000000000000000000000000000000000000000000)
            }

            function read_from_memoryt_bytes1(ptr) -> returnValue {

                let value := cleanup_t_bytes1(mload(ptr))

                returnValue :=

                value

            }

            /// @ast-id 525
            /// @src 0:4257:4511  "function copyBytes(bytes memory source) public pure returns (bytes memory) {..."
            function fun_copyBytes_525(var_source_488_mpos) -> var__491_mpos {
                /// @src 0:4318:4330  "bytes memory"
                let zero_t_bytes_memory_ptr_17_mpos := zero_value_for_split_t_bytes_memory_ptr()
                var__491_mpos := zero_t_bytes_memory_ptr_17_mpos

                /// @src 0:4372:4378  "source"
                let _18_mpos := var_source_488_mpos
                let expr_497_mpos := _18_mpos
                /// @src 0:4372:4385  "source.length"
                let expr_498 := array_length_t_bytes_memory_ptr(expr_497_mpos)
                /// @src 0:4362:4386  "new bytes(source.length)"
                let expr_499_mpos := allocate_and_zero_memory_array_t_bytes_memory_ptr(expr_498)
                /// @src 0:4342:4386  "bytes memory dest = new bytes(source.length)"
                let var_dest_494_mpos := expr_499_mpos
                /// @src 0:4396:4484  "for (uint256 i = 0; i < source.length; i++) {..."
                for {
                    /// @src 0:4413:4414  "0"
                    let expr_503 := 0x00
                    /// @src 0:4401:4414  "uint256 i = 0"
                    let var_i_502 := convert_t_rational_0_by_1_to_t_uint256(expr_503)
                    } 1 {
                    /// @src 0:4435:4438  "i++"
                    let _20 := var_i_502
                    let _19 := increment_wrapping_t_uint256(_20)
                    var_i_502 := _19
                    let expr_510 := _20
                }
                {
                    /// @src 0:4416:4417  "i"
                    let _21 := var_i_502
                    let expr_505 := _21
                    /// @src 0:4420:4426  "source"
                    let _22_mpos := var_source_488_mpos
                    let expr_506_mpos := _22_mpos
                    /// @src 0:4420:4433  "source.length"
                    let expr_507 := array_length_t_bytes_memory_ptr(expr_506_mpos)
                    /// @src 0:4416:4433  "i < source.length"
                    let expr_508 := lt(cleanup_t_uint256(expr_505), cleanup_t_uint256(expr_507))
                    if iszero(expr_508) { break }
                    /// @src 0:4464:4470  "source"
                    let _23_mpos := var_source_488_mpos
                    let expr_515_mpos := _23_mpos
                    /// @src 0:4471:4472  "i"
                    let _24 := var_i_502
                    let expr_516 := _24
                    /// @src 0:4464:4473  "source[i]"
                    let _25 := read_from_memoryt_bytes1(memory_array_index_access_t_bytes_memory_ptr(expr_515_mpos, expr_516))
                    let expr_517 := _25
                    /// @src 0:4454:4458  "dest"
                    let _26_mpos := var_dest_494_mpos
                    let expr_512_mpos := _26_mpos
                    /// @src 0:4459:4460  "i"
                    let _27 := var_i_502
                    let expr_513 := _27
                    /// @src 0:4454:4473  "dest[i] = source[i]"
                    let _28 := expr_517
                    mstore8(memory_array_index_access_t_bytes_memory_ptr(expr_512_mpos, expr_513), byte(0, _28))
                    let expr_518 := expr_517
                }
                /// @src 0:4500:4504  "dest"
                let _29_mpos := var_dest_494_mpos
                let expr_522_mpos := _29_mpos
                /// @src 0:4493:4504  "return dest"
                var__491_mpos := expr_522_mpos
                leave

            }
            /// @src 0:3983:4664  "contract MemoryPatterns {..."

        }

        data ".metadata" hex"a2646970667358221220d2bdbdf2bed2d906d17a41fe676a0e42f93789f1bd9120c96b8d2b9fddbdfc9364736f6c634300081e0033"
    }

}




/// @use-src 0:"test_validation/fixtures/solidity/MainnetComponents.sol"
object "SafeMath_104" {
    code {
        /// @src 0:349:955  "library SafeMath {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("SafeMath_104_deployed"), datasize("SafeMath_104_deployed"))

        setimmutable(_1, "library_deploy_address", address())

        return(_1, datasize("SafeMath_104_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:349:955  "library SafeMath {..."
        function constructor_SafeMath_104() {

            /// @src 0:349:955  "library SafeMath {..."

        }
        /// @src 0:349:955  "library SafeMath {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/MainnetComponents.sol"
    object "SafeMath_104_deployed" {
        code {
            /// @src 0:349:955  "library SafeMath {..."
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

        data ".metadata" hex"a2646970667358221220cdd203566f750f46b6f66d9171f1dd1c0e233ae98ed3e9b9cbece0b45aec5ed464736f6c634300081e0033"
    }

}




/// @use-src 0:"test_validation/fixtures/solidity/MainnetComponents.sol"
object "SimpleStorage_224" {
    code {
        /// @src 0:957:1979  "contract SimpleStorage {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        constructor_SimpleStorage_224()

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("SimpleStorage_224_deployed"), datasize("SimpleStorage_224_deployed"))

        return(_1, datasize("SimpleStorage_224_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        function shift_left_0(value) -> newValue {
            newValue :=

            shl(0, value)

        }

        function update_byte_slice_20_shift_0(value, toInsert) -> result {
            let mask := 0xffffffffffffffffffffffffffffffffffffffff
            toInsert := shift_left_0(toInsert)
            value := and(value, not(mask))
            result := or(value, and(toInsert, mask))
        }

        function cleanup_t_uint160(value) -> cleaned {
            cleaned := and(value, 0xffffffffffffffffffffffffffffffffffffffff)
        }

        function identity(value) -> ret {
            ret := value
        }

        function convert_t_uint160_to_t_uint160(value) -> converted {
            converted := cleanup_t_uint160(identity(cleanup_t_uint160(value)))
        }

        function convert_t_uint160_to_t_address(value) -> converted {
            converted := convert_t_uint160_to_t_uint160(value)
        }

        function convert_t_address_to_t_address(value) -> converted {
            converted := convert_t_uint160_to_t_address(value)
        }

        function prepare_store_t_address(value) -> ret {
            ret := value
        }

        function update_storage_value_offset_0_t_address_to_t_address(slot, value_0) {
            let convertedValue_0 := convert_t_address_to_t_address(value_0)
            sstore(slot, update_byte_slice_20_shift_0(sload(slot), prepare_store_t_address(convertedValue_0)))
        }

        /// @ast-id 133
        /// @src 0:1212:1261  "constructor() {..."
        function constructor_SimpleStorage_224() {

            /// @src 0:1212:1261  "constructor() {..."

            /// @src 0:1244:1254  "msg.sender"
            let expr_129 := caller()
            /// @src 0:1236:1254  "owner = msg.sender"
            update_storage_value_offset_0_t_address_to_t_address(0x02, expr_129)
            let expr_130 := expr_129

        }
        /// @src 0:957:1979  "contract SimpleStorage {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/MainnetComponents.sol"
    object "SimpleStorage_224_deployed" {
        code {
            /// @src 0:957:1979  "contract SimpleStorage {..."
            mstore(64, memoryguard(128))

            if iszero(lt(calldatasize(), 4))
            {
                let selector := shift_right_224_unsigned(calldataload(0))
                switch selector

                case 0x2e1a7d4d
                {
                    // withdraw(uint256)

                    external_fun_withdraw_211()
                }

                case 0x2e64cec1
                {
                    // retrieve()

                    external_fun_retrieve_167()
                }

                case 0x6057361d
                {
                    // store(uint256)

                    external_fun_store_159()
                }

                case 0x8da5cb5b
                {
                    // owner()

                    external_fun_owner_112()
                }

                case 0xd0e30db0
                {
                    // deposit()

                    external_fun_deposit_179()
                }

                case 0xf8b2cb4f
                {
                    // getBalance(address)

                    external_fun_getBalance_223()
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

            function abi_encode_tuple__to__fromStack(headStart ) -> tail {
                tail := add(headStart, 0)

            }

            function external_fun_withdraw_211() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                fun_withdraw_211(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple__to__fromStack(memPos  )
                return(memPos, sub(memEnd, memPos))

            }

            function abi_decode_tuple_(headStart, dataEnd)   {
                if slt(sub(dataEnd, headStart), 0) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

            }

            function abi_encode_t_uint256_to_t_uint256_fromStack(value, pos) {
                mstore(pos, cleanup_t_uint256(value))
            }

            function abi_encode_tuple_t_uint256__to_t_uint256__fromStack(headStart , value0) -> tail {
                tail := add(headStart, 32)

                abi_encode_t_uint256_to_t_uint256_fromStack(value0,  add(headStart, 0))

            }

            function external_fun_retrieve_167() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                abi_decode_tuple_(4, calldatasize())
                let ret_0 :=  fun_retrieve_167()
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_store_159() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                fun_store_159(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple__to__fromStack(memPos  )
                return(memPos, sub(memEnd, memPos))

            }

            function shift_right_unsigned_dynamic(bits, value) -> newValue {
                newValue :=

                shr(bits, value)

            }

            function cleanup_from_storage_t_address(value) -> cleaned {
                cleaned := and(value, 0xffffffffffffffffffffffffffffffffffffffff)
            }

            function extract_from_storage_value_dynamict_address(slot_value, offset) -> value {
                value := cleanup_from_storage_t_address(shift_right_unsigned_dynamic(mul(offset, 8), slot_value))
            }

            function read_from_storage_split_dynamic_t_address(slot, offset) -> value {
                value := extract_from_storage_value_dynamict_address(sload(slot), offset)

            }

            /// @ast-id 112
            /// @src 0:1069:1089  "address public owner"
            function getter_fun_owner_112() -> ret {

                let slot := 2
                let offset := 0

                ret := read_from_storage_split_dynamic_t_address(slot, offset)

            }
            /// @src 0:957:1979  "contract SimpleStorage {..."

            function cleanup_t_uint160(value) -> cleaned {
                cleaned := and(value, 0xffffffffffffffffffffffffffffffffffffffff)
            }

            function cleanup_t_address(value) -> cleaned {
                cleaned := cleanup_t_uint160(value)
            }

            function abi_encode_t_address_to_t_address_fromStack(value, pos) {
                mstore(pos, cleanup_t_address(value))
            }

            function abi_encode_tuple_t_address__to_t_address__fromStack(headStart , value0) -> tail {
                tail := add(headStart, 32)

                abi_encode_t_address_to_t_address_fromStack(value0,  add(headStart, 0))

            }

            function external_fun_owner_112() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                abi_decode_tuple_(4, calldatasize())
                let ret_0 :=  getter_fun_owner_112()
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_address__to_t_address__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_deposit_179() {

                abi_decode_tuple_(4, calldatasize())
                fun_deposit_179()
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple__to__fromStack(memPos  )
                return(memPos, sub(memEnd, memPos))

            }

            function validator_revert_t_address(value) {
                if iszero(eq(value, cleanup_t_address(value))) { revert(0, 0) }
            }

            function abi_decode_t_address(offset, end) -> value {
                value := calldataload(offset)
                validator_revert_t_address(value)
            }

            function abi_decode_tuple_t_address(headStart, dataEnd) -> value0 {
                if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

                {

                    let offset := 0

                    value0 := abi_decode_t_address(add(headStart, offset), dataEnd)
                }

            }

            function external_fun_getBalance_223() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_address(4, calldatasize())
                let ret_0 :=  fun_getBalance_223(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function revert_error_42b3090547df1d2001c96683413b8cf91c1b902ef5e3cb8d9f6f304cf7446f74() {
                revert(0, 0)
            }

            function identity(value) -> ret {
                ret := value
            }

            function convert_t_uint160_to_t_uint160(value) -> converted {
                converted := cleanup_t_uint160(identity(cleanup_t_uint160(value)))
            }

            function convert_t_uint160_to_t_address(value) -> converted {
                converted := convert_t_uint160_to_t_uint160(value)
            }

            function convert_t_address_to_t_address(value) -> converted {
                converted := convert_t_uint160_to_t_address(value)
            }

            function mapping_index_access_t_mapping$_t_address_$_t_uint256_$_of_t_address(slot , key) -> dataSlot {
                mstore(0, convert_t_address_to_t_address(key))
                mstore(0x20, slot)
                dataSlot := keccak256(0, 0x40)
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

            function array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, length) -> updated_pos {
                mstore(pos, length)
                updated_pos := add(pos, 0x20)
            }

            function store_literal_in_memory_47533c3652efd02135ecc34b3fac8efc7b14bf0618b9392fd6e044a3d8a6eef5(memPtr) {

                mstore(add(memPtr, 0), "Insufficient balance")

            }

            function abi_encode_t_stringliteral_47533c3652efd02135ecc34b3fac8efc7b14bf0618b9392fd6e044a3d8a6eef5_to_t_string_memory_ptr_fromStack(pos) -> end {
                pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 20)
                store_literal_in_memory_47533c3652efd02135ecc34b3fac8efc7b14bf0618b9392fd6e044a3d8a6eef5(pos)
                end := add(pos, 32)
            }

            function abi_encode_tuple_t_stringliteral_47533c3652efd02135ecc34b3fac8efc7b14bf0618b9392fd6e044a3d8a6eef5__to_t_string_memory_ptr__fromStack(headStart ) -> tail {
                tail := add(headStart, 32)

                mstore(add(headStart, 0), sub(tail, headStart))
                tail := abi_encode_t_stringliteral_47533c3652efd02135ecc34b3fac8efc7b14bf0618b9392fd6e044a3d8a6eef5_to_t_string_memory_ptr_fromStack( tail)

            }

            function require_helper_t_stringliteral_47533c3652efd02135ecc34b3fac8efc7b14bf0618b9392fd6e044a3d8a6eef5(condition ) {
                if iszero(condition)
                {

                    let memPtr := allocate_unbounded()

                    mstore(memPtr, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                    let end := abi_encode_tuple_t_stringliteral_47533c3652efd02135ecc34b3fac8efc7b14bf0618b9392fd6e044a3d8a6eef5__to_t_string_memory_ptr__fromStack(add(memPtr, 4) )
                    revert(memPtr, sub(end, memPtr))
                }
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

            function convert_t_uint160_to_t_address_payable(value) -> converted {
                converted := convert_t_uint160_to_t_uint160(value)
            }

            function convert_t_address_to_t_address_payable(value) -> converted {
                converted := convert_t_uint160_to_t_address_payable(value)
            }

            function convert_t_address_payable_to_t_address(value) -> converted {
                converted := convert_t_uint160_to_t_address(value)
            }

            function revert_forward_1() {
                let pos := allocate_unbounded()
                returndatacopy(pos, 0, returndatasize())
                revert(pos, returndatasize())
            }

            /// @ast-id 211
            /// @src 0:1656:1863  "function withdraw(uint256 amount) public {..."
            function fun_withdraw_211(var_amount_181) {

                /// @src 0:1715:1723  "balances"
                let _1_slot := 0x01
                let expr_185_slot := _1_slot
                /// @src 0:1724:1734  "msg.sender"
                let expr_187 := caller()
                /// @src 0:1715:1735  "balances[msg.sender]"
                let _2 := mapping_index_access_t_mapping$_t_address_$_t_uint256_$_of_t_address(expr_185_slot,expr_187)
                let _3 := read_from_storage_split_offset_0_t_uint256(_2)
                let expr_188 := _3
                /// @src 0:1739:1745  "amount"
                let _4 := var_amount_181
                let expr_189 := _4
                /// @src 0:1715:1745  "balances[msg.sender] >= amount"
                let expr_190 := iszero(lt(cleanup_t_uint256(expr_188), cleanup_t_uint256(expr_189)))
                /// @src 0:1707:1770  "require(balances[msg.sender] >= amount, \"Insufficient balance\")"
                require_helper_t_stringliteral_47533c3652efd02135ecc34b3fac8efc7b14bf0618b9392fd6e044a3d8a6eef5(expr_190)
                /// @src 0:1804:1810  "amount"
                let _5 := var_amount_181
                let expr_198 := _5
                /// @src 0:1780:1788  "balances"
                let _6_slot := 0x01
                let expr_194_slot := _6_slot
                /// @src 0:1789:1799  "msg.sender"
                let expr_196 := caller()
                /// @src 0:1780:1800  "balances[msg.sender]"
                let _7 := mapping_index_access_t_mapping$_t_address_$_t_uint256_$_of_t_address(expr_194_slot,expr_196)
                /// @src 0:1780:1810  "balances[msg.sender] -= amount"
                let _8 := read_from_storage_split_offset_0_t_uint256(_7)
                let expr_199 := checked_sub_t_uint256(_8, expr_198)

                update_storage_value_offset_0_t_uint256_to_t_uint256(_7, expr_199)
                /// @src 0:1828:1838  "msg.sender"
                let expr_204 := caller()
                /// @src 0:1820:1839  "payable(msg.sender)"
                let expr_205 := convert_t_address_to_t_address_payable(expr_204)
                /// @src 0:1820:1848  "payable(msg.sender).transfer"
                let expr_206_address := convert_t_address_payable_to_t_address(expr_205)
                /// @src 0:1849:1855  "amount"
                let _9 := var_amount_181
                let expr_207 := _9
                /// @src 0:1820:1856  "payable(msg.sender).transfer(amount)"

                let _10 := 0
                if iszero(expr_207) { _10 := 2300 }

                let _11 := call(_10, expr_206_address, expr_207, 0, 0, 0, 0)

                if iszero(_11) { revert_forward_1() }

            }
            /// @src 0:957:1979  "contract SimpleStorage {..."

            function zero_value_for_split_t_uint256() -> ret {
                ret := 0
            }

            /// @ast-id 167
            /// @src 0:1475:1560  "function retrieve() public view returns (uint256) {..."
            function fun_retrieve_167() -> var__162 {
                /// @src 0:1516:1523  "uint256"
                let zero_t_uint256_12 := zero_value_for_split_t_uint256()
                var__162 := zero_t_uint256_12

                /// @src 0:1542:1553  "storedValue"
                let _13 := read_from_storage_split_offset_0_t_uint256(0x00)
                let expr_164 := _13
                /// @src 0:1535:1553  "return storedValue"
                var__162 := expr_164
                leave

            }
            /// @src 0:957:1979  "contract SimpleStorage {..."

            /// @ast-id 159
            /// @src 0:1363:1469  "function store(uint256 value) public {..."
            function fun_store_159(var_value_147) {

                /// @src 0:1424:1429  "value"
                let _14 := var_value_147
                let expr_151 := _14
                /// @src 0:1410:1429  "storedValue = value"
                update_storage_value_offset_0_t_uint256_to_t_uint256(0x00, expr_151)
                let expr_152 := expr_151
                /// @src 0:1456:1461  "value"
                let _15 := var_value_147
                let expr_155 := _15
                /// @src 0:1444:1462  "ValueStored(value)"
                let _16 := 0xd96380bfdcd65b46c34933d1975be366bab1bf64a46131cc7802bf14f094cc84
                {
                    let _17 := allocate_unbounded()
                    let _18 := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(_17 , expr_155)
                    log1(_17, sub(_18, _17) , _16)
                }
            }
            /// @src 0:957:1979  "contract SimpleStorage {..."

            function checked_add_t_uint256(x, y) -> sum {
                x := cleanup_t_uint256(x)
                y := cleanup_t_uint256(y)
                sum := add(x, y)

                if gt(x, sum) { panic_error_0x11() }

            }

            /// @ast-id 179
            /// @src 0:1566:1650  "function deposit() public payable {..."
            function fun_deposit_179() {

                /// @src 0:1634:1643  "msg.value"
                let expr_175 := callvalue()
                /// @src 0:1610:1618  "balances"
                let _19_slot := 0x01
                let expr_170_slot := _19_slot
                /// @src 0:1619:1629  "msg.sender"
                let expr_172 := caller()
                /// @src 0:1610:1630  "balances[msg.sender]"
                let _20 := mapping_index_access_t_mapping$_t_address_$_t_uint256_$_of_t_address(expr_170_slot,expr_172)
                /// @src 0:1610:1643  "balances[msg.sender] += msg.value"
                let _21 := read_from_storage_split_offset_0_t_uint256(_20)
                let expr_176 := checked_add_t_uint256(_21, expr_175)

                update_storage_value_offset_0_t_uint256_to_t_uint256(_20, expr_176)

            }
            /// @src 0:957:1979  "contract SimpleStorage {..."

            /// @ast-id 223
            /// @src 0:1869:1977  "function getBalance(address account) public view returns (uint256) {..."
            function fun_getBalance_223(var_account_213) -> var__216 {
                /// @src 0:1927:1934  "uint256"
                let zero_t_uint256_22 := zero_value_for_split_t_uint256()
                var__216 := zero_t_uint256_22

                /// @src 0:1953:1961  "balances"
                let _23_slot := 0x01
                let expr_218_slot := _23_slot
                /// @src 0:1962:1969  "account"
                let _24 := var_account_213
                let expr_219 := _24
                /// @src 0:1953:1970  "balances[account]"
                let _25 := mapping_index_access_t_mapping$_t_address_$_t_uint256_$_of_t_address(expr_218_slot,expr_219)
                let _26 := read_from_storage_split_offset_0_t_uint256(_25)
                let expr_220 := _26
                /// @src 0:1946:1970  "return balances[account]"
                var__216 := expr_220
                leave

            }
            /// @src 0:957:1979  "contract SimpleStorage {..."

        }

        data ".metadata" hex"a2646970667358221220865e344c23421e6352ea5d6a6b747f6556b019f0f91525a6c5a1ec5bbd7633d264736f6c634300081e0033"
    }

}

