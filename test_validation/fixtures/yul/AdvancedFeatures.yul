
/// @use-src 0:"test_validation/fixtures/solidity/AdvancedFeatures.sol"
object "AdvancedFeatures_256" {
    code {
        /// @src 0:58:1932  "contract AdvancedFeatures {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        constructor_AdvancedFeatures_256()

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("AdvancedFeatures_256_deployed"), datasize("AdvancedFeatures_256_deployed"))

        return(_1, datasize("AdvancedFeatures_256_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:58:1932  "contract AdvancedFeatures {..."
        function constructor_AdvancedFeatures_256() {

            /// @src 0:58:1932  "contract AdvancedFeatures {..."

        }
        /// @src 0:58:1932  "contract AdvancedFeatures {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/AdvancedFeatures.sol"
    object "AdvancedFeatures_256_deployed" {
        code {
            /// @src 0:58:1932  "contract AdvancedFeatures {..."
            mstore(64, memoryguard(128))

            if iszero(lt(calldatasize(), 4))
            {
                let selector := shift_right_224_unsigned(calldataload(0))
                switch selector

                case 0x2e1a7d4d
                {
                    // withdraw(uint256)

                    external_fun_withdraw_83()
                }

                case 0x6f77926b
                {
                    // getUser(address)

                    external_fun_getUser_106()
                }

                case 0x7649c433
                {
                    // historyAverage()

                    external_fun_historyAverage_160()
                }

                case 0x83714834
                {
                    // factorial(uint256)

                    external_fun_factorial_197()
                }

                case 0xb6b55f25
                {
                    // deposit(uint256)

                    external_fun_deposit_49()
                }

                case 0xc557abe6
                {
                    // historySum()

                    external_fun_historySum_137()
                }

                case 0xc6c2ea17
                {
                    // fib(uint256)

                    external_fun_fib_255()
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

            function external_fun_withdraw_83() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                fun_withdraw_83(param_0)
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

            function abi_encode_t_uint256_to_t_uint256_fromStack(value, pos) {
                mstore(pos, cleanup_t_uint256(value))
            }

            function abi_encode_tuple_t_uint256_t_uint256__to_t_uint256_t_uint256__fromStack(headStart , value0, value1) -> tail {
                tail := add(headStart, 64)

                abi_encode_t_uint256_to_t_uint256_fromStack(value0,  add(headStart, 0))

                abi_encode_t_uint256_to_t_uint256_fromStack(value1,  add(headStart, 32))

            }

            function external_fun_getUser_106() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_address(4, calldatasize())
                let ret_0, ret_1 :=  fun_getUser_106(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256_t_uint256__to_t_uint256_t_uint256__fromStack(memPos , ret_0, ret_1)
                return(memPos, sub(memEnd, memPos))

            }

            function abi_decode_tuple_(headStart, dataEnd)   {
                if slt(sub(dataEnd, headStart), 0) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

            }

            function abi_encode_tuple_t_uint256__to_t_uint256__fromStack(headStart , value0) -> tail {
                tail := add(headStart, 32)

                abi_encode_t_uint256_to_t_uint256_fromStack(value0,  add(headStart, 0))

            }

            function external_fun_historyAverage_160() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                abi_decode_tuple_(4, calldatasize())
                let ret_0 :=  fun_historyAverage_160()
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_factorial_197() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                let ret_0 :=  fun_factorial_197(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_deposit_49() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                fun_deposit_49(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple__to__fromStack(memPos  )
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_historySum_137() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                abi_decode_tuple_(4, calldatasize())
                let ret_0 :=  fun_historySum_137()
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_fib_255() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                let ret_0 :=  fun_fib_255(param_0)
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

            function mapping_index_access_t_mapping$_t_address_$_t_struct$_User_$6_storage_$_of_t_address(slot , key) -> dataSlot {
                mstore(0, convert_t_address_to_t_address(key))
                mstore(0x20, slot)
                dataSlot := keccak256(0, 0x40)
            }

            function convert_t_struct$_User_$6_storage_to_t_struct$_User_$6_storage_ptr(value) -> converted {
                converted := value
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

            function store_literal_in_memory_1d6424f41c888659cfd6cfa52fead9c914e6f8687116697f5c9ecb1e5532665d(memPtr) {

                mstore(add(memPtr, 0), "insufficient")

            }

            function abi_encode_t_stringliteral_1d6424f41c888659cfd6cfa52fead9c914e6f8687116697f5c9ecb1e5532665d_to_t_string_memory_ptr_fromStack(pos) -> end {
                pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 12)
                store_literal_in_memory_1d6424f41c888659cfd6cfa52fead9c914e6f8687116697f5c9ecb1e5532665d(pos)
                end := add(pos, 32)
            }

            function abi_encode_tuple_t_stringliteral_1d6424f41c888659cfd6cfa52fead9c914e6f8687116697f5c9ecb1e5532665d__to_t_string_memory_ptr__fromStack(headStart ) -> tail {
                tail := add(headStart, 32)

                mstore(add(headStart, 0), sub(tail, headStart))
                tail := abi_encode_t_stringliteral_1d6424f41c888659cfd6cfa52fead9c914e6f8687116697f5c9ecb1e5532665d_to_t_string_memory_ptr_fromStack( tail)

            }

            function require_helper_t_stringliteral_1d6424f41c888659cfd6cfa52fead9c914e6f8687116697f5c9ecb1e5532665d(condition ) {
                if iszero(condition)
                {

                    let memPtr := allocate_unbounded()

                    mstore(memPtr, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                    let end := abi_encode_tuple_t_stringliteral_1d6424f41c888659cfd6cfa52fead9c914e6f8687116697f5c9ecb1e5532665d__to_t_string_memory_ptr__fromStack(add(memPtr, 4) )
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

            function cleanup_t_rational_1_by_1(value) -> cleaned {
                cleaned := value
            }

            function convert_t_rational_1_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_1_by_1(value)))
            }

            function checked_add_t_uint256(x, y) -> sum {
                x := cleanup_t_uint256(x)
                y := cleanup_t_uint256(y)
                sum := add(x, y)

                if gt(x, sum) { panic_error_0x11() }

            }

            /// @ast-id 83
            /// @src 0:459:673  "function withdraw(uint256 amount) public {..."
            function fun_withdraw_83(var_amount_51) {

                /// @src 0:530:535  "users"
                let _1_slot := 0x00
                let expr_57_slot := _1_slot
                /// @src 0:536:546  "msg.sender"
                let expr_59 := caller()
                /// @src 0:530:547  "users[msg.sender]"
                let _2 := mapping_index_access_t_mapping$_t_address_$_t_struct$_User_$6_storage_$_of_t_address(expr_57_slot,expr_59)
                let _3_slot := _2
                let expr_60_slot := _3_slot
                /// @src 0:510:547  "User storage user = users[msg.sender]"
                let var_user_56_slot := convert_t_struct$_User_$6_storage_to_t_struct$_User_$6_storage_ptr(expr_60_slot)
                /// @src 0:565:569  "user"
                let _4_slot := var_user_56_slot
                let expr_63_slot := _4_slot
                /// @src 0:565:577  "user.balance"
                let _5 := add(expr_63_slot, 0)
                let _6 := read_from_storage_split_offset_0_t_uint256(_5)
                let expr_64 := _6
                /// @src 0:581:587  "amount"
                let _7 := var_amount_51
                let expr_65 := _7
                /// @src 0:565:587  "user.balance >= amount"
                let expr_66 := iszero(lt(cleanup_t_uint256(expr_64), cleanup_t_uint256(expr_65)))
                /// @src 0:557:604  "require(user.balance >= amount, \"insufficient\")"
                require_helper_t_stringliteral_1d6424f41c888659cfd6cfa52fead9c914e6f8687116697f5c9ecb1e5532665d(expr_66)
                /// @src 0:630:636  "amount"
                let _8 := var_amount_51
                let expr_73 := _8
                /// @src 0:614:618  "user"
                let _9_slot := var_user_56_slot
                let expr_70_slot := _9_slot
                /// @src 0:614:626  "user.balance"
                let _10 := add(expr_70_slot, 0)
                /// @src 0:614:636  "user.balance -= amount"
                let _11 := read_from_storage_split_offset_0_t_uint256(_10)
                let expr_74 := checked_sub_t_uint256(_11, expr_73)

                update_storage_value_offset_0_t_uint256_to_t_uint256(_10, expr_74)
                /// @src 0:665:666  "1"
                let expr_79 := 0x01
                /// @src 0:646:666  "user.operations += 1"
                let _12 := convert_t_rational_1_by_1_to_t_uint256(expr_79)
                /// @src 0:646:650  "user"
                let _13_slot := var_user_56_slot
                let expr_76_slot := _13_slot
                /// @src 0:646:661  "user.operations"
                let _14 := add(expr_76_slot, 1)
                /// @src 0:646:666  "user.operations += 1"
                let _15 := read_from_storage_split_offset_0_t_uint256(_14)
                let expr_80 := checked_add_t_uint256(_15, _12)

                update_storage_value_offset_0_t_uint256_to_t_uint256(_14, expr_80)

            }
            /// @src 0:58:1932  "contract AdvancedFeatures {..."

            function zero_value_for_split_t_uint256() -> ret {
                ret := 0
            }

            /// @ast-id 106
            /// @src 0:679:870  "function getUser(address account) public view returns (uint256 balance, uint256 operations) {..."
            function fun_getUser_106(var_account_85) -> var_balance_88, var_operations_90 {
                /// @src 0:734:749  "uint256 balance"
                let zero_t_uint256_16 := zero_value_for_split_t_uint256()
                var_balance_88 := zero_t_uint256_16
                /// @src 0:751:769  "uint256 operations"
                let zero_t_uint256_17 := zero_value_for_split_t_uint256()
                var_operations_90 := zero_t_uint256_17

                /// @src 0:801:806  "users"
                let _18_slot := 0x00
                let expr_95_slot := _18_slot
                /// @src 0:807:814  "account"
                let _19 := var_account_85
                let expr_96 := _19
                /// @src 0:801:815  "users[account]"
                let _20 := mapping_index_access_t_mapping$_t_address_$_t_struct$_User_$6_storage_$_of_t_address(expr_95_slot,expr_96)
                let _21_slot := _20
                let expr_97_slot := _21_slot
                /// @src 0:781:815  "User storage user = users[account]"
                let var_user_94_slot := convert_t_struct$_User_$6_storage_to_t_struct$_User_$6_storage_ptr(expr_97_slot)
                /// @src 0:833:837  "user"
                let _22_slot := var_user_94_slot
                let expr_99_slot := _22_slot
                /// @src 0:833:845  "user.balance"
                let _23 := add(expr_99_slot, 0)
                let _24 := read_from_storage_split_offset_0_t_uint256(_23)
                let expr_100 := _24
                /// @src 0:832:863  "(user.balance, user.operations)"
                let expr_103_component_1 := expr_100
                /// @src 0:847:851  "user"
                let _25_slot := var_user_94_slot
                let expr_101_slot := _25_slot
                /// @src 0:847:862  "user.operations"
                let _26 := add(expr_101_slot, 1)
                let _27 := read_from_storage_split_offset_0_t_uint256(_26)
                let expr_102 := _27
                /// @src 0:832:863  "(user.balance, user.operations)"
                let expr_103_component_2 := expr_102
                /// @src 0:825:863  "return (user.balance, user.operations)"
                var_balance_88 := expr_103_component_1
                var_operations_90 := expr_103_component_2
                leave

            }
            /// @src 0:58:1932  "contract AdvancedFeatures {..."

            function array_length_t_array$_t_uint256_$dyn_storage(value) -> length {

                length := sload(value)

            }

            function cleanup_t_rational_0_by_1(value) -> cleaned {
                cleaned := value
            }

            function convert_t_rational_0_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_0_by_1(value)))
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

            /// @ast-id 160
            /// @src 0:1082:1283  "function historyAverage() public view returns (uint256) {..."
            function fun_historyAverage_160() -> var__140 {
                /// @src 0:1129:1136  "uint256"
                let zero_t_uint256_28 := zero_value_for_split_t_uint256()
                var__140 := zero_t_uint256_28

                /// @src 0:1165:1172  "history"
                let _29_slot := 0x01
                let expr_144_slot := _29_slot
                /// @src 0:1165:1179  "history.length"
                let expr_145 := array_length_t_array$_t_uint256_$dyn_storage(expr_144_slot)
                /// @src 0:1148:1179  "uint256 length = history.length"
                let var_length_143 := expr_145
                /// @src 0:1193:1199  "length"
                let _30 := var_length_143
                let expr_147 := _30
                /// @src 0:1203:1204  "0"
                let expr_148 := 0x00
                /// @src 0:1193:1204  "length == 0"
                let expr_149 := eq(cleanup_t_uint256(expr_147), convert_t_rational_0_by_1_to_t_uint256(expr_148))
                /// @src 0:1189:1239  "if (length == 0) {..."
                if expr_149 {
                    /// @src 0:1227:1228  "0"
                    let expr_150 := 0x00
                    /// @src 0:1220:1228  "return 0"
                    var__140 := convert_t_rational_0_by_1_to_t_uint256(expr_150)
                    leave
                    /// @src 0:1189:1239  "if (length == 0) {..."
                }
                /// @src 0:1255:1267  "historySum()"
                let expr_155 := fun_historySum_137()
                /// @src 0:1270:1276  "length"
                let _31 := var_length_143
                let expr_156 := _31
                /// @src 0:1255:1276  "historySum() / length"
                let expr_157 := checked_div_t_uint256(expr_155, expr_156)

                /// @src 0:1248:1276  "return historySum() / length"
                var__140 := expr_157
                leave

            }
            /// @src 0:58:1932  "contract AdvancedFeatures {..."

            function cleanup_t_rational_2_by_1(value) -> cleaned {
                cleaned := value
            }

            function convert_t_rational_2_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_2_by_1(value)))
            }

            function increment_t_uint256(value) -> ret {
                value := cleanup_t_uint256(value)
                if eq(value, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) { panic_error_0x11() }
                ret := add(value, 1)
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

            /// @ast-id 197
            /// @src 0:1289:1539  "function factorial(uint256 n) public pure returns (uint256) {..."
            function fun_factorial_197(var_n_162) -> var__165 {
                /// @src 0:1340:1347  "uint256"
                let zero_t_uint256_32 := zero_value_for_split_t_uint256()
                var__165 := zero_t_uint256_32

                /// @src 0:1363:1364  "n"
                let _33 := var_n_162
                let expr_167 := _33
                /// @src 0:1368:1369  "0"
                let expr_168 := 0x00
                /// @src 0:1363:1369  "n == 0"
                let expr_169 := eq(cleanup_t_uint256(expr_167), convert_t_rational_0_by_1_to_t_uint256(expr_168))
                /// @src 0:1359:1404  "if (n == 0) {..."
                if expr_169 {
                    /// @src 0:1392:1393  "1"
                    let expr_170 := 0x01
                    /// @src 0:1385:1393  "return 1"
                    var__165 := convert_t_rational_1_by_1_to_t_uint256(expr_170)
                    leave
                    /// @src 0:1359:1404  "if (n == 0) {..."
                }
                /// @src 0:1430:1431  "1"
                let expr_176 := 0x01
                /// @src 0:1413:1431  "uint256 result = 1"
                let var_result_175 := convert_t_rational_1_by_1_to_t_uint256(expr_176)
                /// @src 0:1441:1510  "for (uint256 i = 2; i <= n; i++) {..."
                for {
                    /// @src 0:1458:1459  "2"
                    let expr_180 := 0x02
                    /// @src 0:1446:1459  "uint256 i = 2"
                    let var_i_179 := convert_t_rational_2_by_1_to_t_uint256(expr_180)
                    } 1 {
                    /// @src 0:1469:1472  "i++"
                    let _35 := var_i_179
                    let _34 := increment_t_uint256(_35)
                    var_i_179 := _34
                    let expr_186 := _35
                }
                {
                    /// @src 0:1461:1462  "i"
                    let _36 := var_i_179
                    let expr_182 := _36
                    /// @src 0:1466:1467  "n"
                    let _37 := var_n_162
                    let expr_183 := _37
                    /// @src 0:1461:1467  "i <= n"
                    let expr_184 := iszero(gt(cleanup_t_uint256(expr_182), cleanup_t_uint256(expr_183)))
                    if iszero(expr_184) { break }
                    /// @src 0:1498:1499  "i"
                    let _38 := var_i_179
                    let expr_189 := _38
                    /// @src 0:1488:1499  "result *= i"
                    let _39 := var_result_175
                    let expr_190 := checked_mul_t_uint256(_39, expr_189)

                    var_result_175 := expr_190
                }
                /// @src 0:1526:1532  "result"
                let _40 := var_result_175
                let expr_194 := _40
                /// @src 0:1519:1532  "return result"
                var__165 := expr_194
                leave

            }
            /// @src 0:58:1932  "contract AdvancedFeatures {..."

            function store_literal_in_memory_7a4b27aca3817e208aeec5219b8023ae68f7f4a75daa22a4be89e1a2b2c69b92(memPtr) {

                mstore(add(memPtr, 0), "amount zero")

            }

            function abi_encode_t_stringliteral_7a4b27aca3817e208aeec5219b8023ae68f7f4a75daa22a4be89e1a2b2c69b92_to_t_string_memory_ptr_fromStack(pos) -> end {
                pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 11)
                store_literal_in_memory_7a4b27aca3817e208aeec5219b8023ae68f7f4a75daa22a4be89e1a2b2c69b92(pos)
                end := add(pos, 32)
            }

            function abi_encode_tuple_t_stringliteral_7a4b27aca3817e208aeec5219b8023ae68f7f4a75daa22a4be89e1a2b2c69b92__to_t_string_memory_ptr__fromStack(headStart ) -> tail {
                tail := add(headStart, 32)

                mstore(add(headStart, 0), sub(tail, headStart))
                tail := abi_encode_t_stringliteral_7a4b27aca3817e208aeec5219b8023ae68f7f4a75daa22a4be89e1a2b2c69b92_to_t_string_memory_ptr_fromStack( tail)

            }

            function require_helper_t_stringliteral_7a4b27aca3817e208aeec5219b8023ae68f7f4a75daa22a4be89e1a2b2c69b92(condition ) {
                if iszero(condition)
                {

                    let memPtr := allocate_unbounded()

                    mstore(memPtr, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                    let end := abi_encode_tuple_t_stringliteral_7a4b27aca3817e208aeec5219b8023ae68f7f4a75daa22a4be89e1a2b2c69b92__to_t_string_memory_ptr__fromStack(add(memPtr, 4) )
                    revert(memPtr, sub(end, memPtr))
                }
            }

            function convert_array_t_array$_t_uint256_$dyn_storage_to_t_array$_t_uint256_$dyn_storage_ptr(value) -> converted  {
                converted := value

            }

            function panic_error_0x41() {
                mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                mstore(4, 0x41)
                revert(0, 0x24)
            }

            function array_dataslot_t_array$_t_uint256_$dyn_storage_ptr(ptr) -> data {
                data := ptr

                mstore(0, ptr)
                data := keccak256(0, 0x20)

            }

            function panic_error_0x32() {
                mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                mstore(4, 0x32)
                revert(0, 0x24)
            }

            function array_length_t_array$_t_uint256_$dyn_storage_ptr(value) -> length {

                length := sload(value)

            }

            function array_dataslot_t_bytes_storage_ptr(ptr) -> data {
                data := ptr

                mstore(0, ptr)
                data := keccak256(0, 0x20)

            }

            function long_byte_array_index_access_no_checks(array, index) -> slot, offset {

                offset := sub(31, mod(index, 0x20))
                let dataArea := array_dataslot_t_bytes_storage_ptr(array)
                slot := add(dataArea, div(index, 0x20))

            }

            function storage_array_index_access_t_array$_t_uint256_$dyn_storage_ptr(array, index) -> slot, offset {
                let arrayLength := array_length_t_array$_t_uint256_$dyn_storage_ptr(array)
                if iszero(lt(index, arrayLength)) { panic_error_0x32() }

                let dataArea := array_dataslot_t_array$_t_uint256_$dyn_storage_ptr(array)
                slot := add(dataArea, mul(index, 1))
                offset := 0

            }

            function shift_left_dynamic(bits, value) -> newValue {
                newValue :=

                shl(bits, value)

            }

            function update_byte_slice_dynamic32(value, shiftBytes, toInsert) -> result {
                let shiftBits := mul(shiftBytes, 8)
                let mask := shift_left_dynamic(shiftBits, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
                toInsert := shift_left_dynamic(shiftBits, toInsert)
                value := and(value, not(mask))
                result := or(value, and(toInsert, mask))
            }

            function update_storage_value_t_uint256_to_t_uint256(slot, offset, value_0) {
                let convertedValue_0 := convert_t_uint256_to_t_uint256(value_0)
                sstore(slot, update_byte_slice_dynamic32(sload(slot), offset, prepare_store_t_uint256(convertedValue_0)))
            }

            function array_push_from_t_uint256_to_t_array$_t_uint256_$dyn_storage_ptr(array , value0) {

                let oldLen := sload(array)
                if iszero(lt(oldLen, 18446744073709551616)) { panic_error_0x41() }
                sstore(array, add(oldLen, 1))
                let slot, offset := storage_array_index_access_t_array$_t_uint256_$dyn_storage_ptr(array, oldLen)
                update_storage_value_t_uint256_to_t_uint256(slot, offset , value0)

            }
            /// @ast-id 49
            /// @src 0:244:453  "function deposit(uint256 amount) public {..."
            function fun_deposit_49(var_amount_16) {

                /// @src 0:302:308  "amount"
                let _41 := var_amount_16
                let expr_20 := _41
                /// @src 0:311:312  "0"
                let expr_21 := 0x00
                /// @src 0:302:312  "amount > 0"
                let expr_22 := gt(cleanup_t_uint256(expr_20), convert_t_rational_0_by_1_to_t_uint256(expr_21))
                /// @src 0:294:328  "require(amount > 0, \"amount zero\")"
                require_helper_t_stringliteral_7a4b27aca3817e208aeec5219b8023ae68f7f4a75daa22a4be89e1a2b2c69b92(expr_22)
                /// @src 0:367:373  "amount"
                let _42 := var_amount_16
                let expr_31 := _42
                /// @src 0:338:343  "users"
                let _43_slot := 0x00
                let expr_26_slot := _43_slot
                /// @src 0:344:354  "msg.sender"
                let expr_28 := caller()
                /// @src 0:338:355  "users[msg.sender]"
                let _44 := mapping_index_access_t_mapping$_t_address_$_t_struct$_User_$6_storage_$_of_t_address(expr_26_slot,expr_28)
                let _45_slot := _44
                let expr_29_slot := _45_slot
                /// @src 0:338:363  "users[msg.sender].balance"
                let _46 := add(expr_29_slot, 0)
                /// @src 0:338:373  "users[msg.sender].balance += amount"
                let _47 := read_from_storage_split_offset_0_t_uint256(_46)
                let expr_32 := checked_add_t_uint256(_47, expr_31)

                update_storage_value_offset_0_t_uint256_to_t_uint256(_46, expr_32)
                /// @src 0:415:416  "1"
                let expr_39 := 0x01
                /// @src 0:383:416  "users[msg.sender].operations += 1"
                let _48 := convert_t_rational_1_by_1_to_t_uint256(expr_39)
                /// @src 0:383:388  "users"
                let _49_slot := 0x00
                let expr_34_slot := _49_slot
                /// @src 0:389:399  "msg.sender"
                let expr_36 := caller()
                /// @src 0:383:400  "users[msg.sender]"
                let _50 := mapping_index_access_t_mapping$_t_address_$_t_struct$_User_$6_storage_$_of_t_address(expr_34_slot,expr_36)
                let _51_slot := _50
                let expr_37_slot := _51_slot
                /// @src 0:383:411  "users[msg.sender].operations"
                let _52 := add(expr_37_slot, 1)
                /// @src 0:383:416  "users[msg.sender].operations += 1"
                let _53 := read_from_storage_split_offset_0_t_uint256(_52)
                let expr_40 := checked_add_t_uint256(_53, _48)

                update_storage_value_offset_0_t_uint256_to_t_uint256(_52, expr_40)
                /// @src 0:426:433  "history"
                let _54_slot := 0x01
                let expr_42_slot := _54_slot
                /// @src 0:426:438  "history.push"
                let expr_44_self_slot := convert_array_t_array$_t_uint256_$dyn_storage_to_t_array$_t_uint256_$dyn_storage_ptr(expr_42_slot)
                /// @src 0:439:445  "amount"
                let _55 := var_amount_16
                let expr_45 := _55
                /// @src 0:426:446  "history.push(amount)"
                array_push_from_t_uint256_to_t_array$_t_uint256_$dyn_storage_ptr(expr_44_self_slot, expr_45)

            }
            /// @src 0:58:1932  "contract AdvancedFeatures {..."

            function increment_wrapping_t_uint256(value) -> ret {
                ret := cleanup_t_uint256(add(value, 1))
            }

            function array_dataslot_t_array$_t_uint256_$dyn_storage(ptr) -> data {
                data := ptr

                mstore(0, ptr)
                data := keccak256(0, 0x20)

            }

            function storage_array_index_access_t_array$_t_uint256_$dyn_storage(array, index) -> slot, offset {
                let arrayLength := array_length_t_array$_t_uint256_$dyn_storage(array)
                if iszero(lt(index, arrayLength)) { panic_error_0x32() }

                let dataArea := array_dataslot_t_array$_t_uint256_$dyn_storage(array)
                slot := add(dataArea, mul(index, 1))
                offset := 0

            }

            function shift_right_unsigned_dynamic(bits, value) -> newValue {
                newValue :=

                shr(bits, value)

            }

            function extract_from_storage_value_dynamict_uint256(slot_value, offset) -> value {
                value := cleanup_from_storage_t_uint256(shift_right_unsigned_dynamic(mul(offset, 8), slot_value))
            }

            function read_from_storage_split_dynamic_t_uint256(slot, offset) -> value {
                value := extract_from_storage_value_dynamict_uint256(sload(slot), offset)

            }

            /// @ast-id 137
            /// @src 0:876:1076  "function historySum() public view returns (uint256) {..."
            function fun_historySum_137() -> var__109 {
                /// @src 0:919:926  "uint256"
                let zero_t_uint256_56 := zero_value_for_split_t_uint256()
                var__109 := zero_t_uint256_56

                /// @src 0:952:953  "0"
                let expr_113 := 0x00
                /// @src 0:938:953  "uint256 sum = 0"
                let var_sum_112 := convert_t_rational_0_by_1_to_t_uint256(expr_113)
                /// @src 0:963:1050  "for (uint256 i = 0; i < history.length; i++) {..."
                for {
                    /// @src 0:980:981  "0"
                    let expr_117 := 0x00
                    /// @src 0:968:981  "uint256 i = 0"
                    let var_i_116 := convert_t_rational_0_by_1_to_t_uint256(expr_117)
                    } 1 {
                    /// @src 0:1003:1006  "i++"
                    let _58 := var_i_116
                    let _57 := increment_wrapping_t_uint256(_58)
                    var_i_116 := _57
                    let expr_124 := _58
                }
                {
                    /// @src 0:983:984  "i"
                    let _59 := var_i_116
                    let expr_119 := _59
                    /// @src 0:987:994  "history"
                    let _60_slot := 0x01
                    let expr_120_slot := _60_slot
                    /// @src 0:987:1001  "history.length"
                    let expr_121 := array_length_t_array$_t_uint256_$dyn_storage(expr_120_slot)
                    /// @src 0:983:1001  "i < history.length"
                    let expr_122 := lt(cleanup_t_uint256(expr_119), cleanup_t_uint256(expr_121))
                    if iszero(expr_122) { break }
                    /// @src 0:1029:1036  "history"
                    let _61_slot := 0x01
                    let expr_127_slot := _61_slot
                    /// @src 0:1037:1038  "i"
                    let _62 := var_i_116
                    let expr_128 := _62
                    /// @src 0:1029:1039  "history[i]"

                    let _63, _64 := storage_array_index_access_t_array$_t_uint256_$dyn_storage(expr_127_slot, expr_128)
                    let _65 := read_from_storage_split_dynamic_t_uint256(_63, _64)
                    let expr_129 := _65
                    /// @src 0:1022:1039  "sum += history[i]"
                    let _66 := var_sum_112
                    let expr_130 := checked_add_t_uint256(_66, expr_129)

                    var_sum_112 := expr_130
                }
                /// @src 0:1066:1069  "sum"
                let _67 := var_sum_112
                let expr_134 := _67
                /// @src 0:1059:1069  "return sum"
                var__109 := expr_134
                leave

            }
            /// @src 0:58:1932  "contract AdvancedFeatures {..."

            /// @ast-id 255
            /// @src 0:1545:1930  "function fib(uint256 n) public pure returns (uint256) {..."
            function fun_fib_255(var_n_199) -> var__202 {
                /// @src 0:1590:1597  "uint256"
                let zero_t_uint256_68 := zero_value_for_split_t_uint256()
                var__202 := zero_t_uint256_68

                /// @src 0:1613:1614  "n"
                let _69 := var_n_199
                let expr_204 := _69
                /// @src 0:1618:1619  "0"
                let expr_205 := 0x00
                /// @src 0:1613:1619  "n == 0"
                let expr_206 := eq(cleanup_t_uint256(expr_204), convert_t_rational_0_by_1_to_t_uint256(expr_205))
                /// @src 0:1609:1654  "if (n == 0) {..."
                if expr_206 {
                    /// @src 0:1642:1643  "0"
                    let expr_207 := 0x00
                    /// @src 0:1635:1643  "return 0"
                    var__202 := convert_t_rational_0_by_1_to_t_uint256(expr_207)
                    leave
                    /// @src 0:1609:1654  "if (n == 0) {..."
                }
                /// @src 0:1667:1668  "n"
                let _70 := var_n_199
                let expr_211 := _70
                /// @src 0:1672:1673  "1"
                let expr_212 := 0x01
                /// @src 0:1667:1673  "n == 1"
                let expr_213 := eq(cleanup_t_uint256(expr_211), convert_t_rational_1_by_1_to_t_uint256(expr_212))
                /// @src 0:1663:1708  "if (n == 1) {..."
                if expr_213 {
                    /// @src 0:1696:1697  "1"
                    let expr_214 := 0x01
                    /// @src 0:1689:1697  "return 1"
                    var__202 := convert_t_rational_1_by_1_to_t_uint256(expr_214)
                    leave
                    /// @src 0:1663:1708  "if (n == 1) {..."
                }
                /// @src 0:1732:1733  "0"
                let expr_220 := 0x00
                /// @src 0:1717:1733  "uint256 prev = 0"
                let var_prev_219 := convert_t_rational_0_by_1_to_t_uint256(expr_220)
                /// @src 0:1758:1759  "1"
                let expr_224 := 0x01
                /// @src 0:1743:1759  "uint256 curr = 1"
                let var_curr_223 := convert_t_rational_1_by_1_to_t_uint256(expr_224)
                /// @src 0:1769:1903  "for (uint256 i = 2; i <= n; i++) {..."
                for {
                    /// @src 0:1786:1787  "2"
                    let expr_228 := 0x02
                    /// @src 0:1774:1787  "uint256 i = 2"
                    let var_i_227 := convert_t_rational_2_by_1_to_t_uint256(expr_228)
                    } 1 {
                    /// @src 0:1797:1800  "i++"
                    let _72 := var_i_227
                    let _71 := increment_t_uint256(_72)
                    var_i_227 := _71
                    let expr_234 := _72
                }
                {
                    /// @src 0:1789:1790  "i"
                    let _73 := var_i_227
                    let expr_230 := _73
                    /// @src 0:1794:1795  "n"
                    let _74 := var_n_199
                    let expr_231 := _74
                    /// @src 0:1789:1795  "i <= n"
                    let expr_232 := iszero(gt(cleanup_t_uint256(expr_230), cleanup_t_uint256(expr_231)))
                    if iszero(expr_232) { break }
                    /// @src 0:1831:1835  "prev"
                    let _75 := var_prev_219
                    let expr_238 := _75
                    /// @src 0:1838:1842  "curr"
                    let _76 := var_curr_223
                    let expr_239 := _76
                    /// @src 0:1831:1842  "prev + curr"
                    let expr_240 := checked_add_t_uint256(expr_238, expr_239)

                    /// @src 0:1816:1842  "uint256 next = prev + curr"
                    let var_next_237 := expr_240
                    /// @src 0:1863:1867  "curr"
                    let _77 := var_curr_223
                    let expr_243 := _77
                    /// @src 0:1856:1867  "prev = curr"
                    var_prev_219 := expr_243
                    let expr_244 := expr_243
                    /// @src 0:1888:1892  "next"
                    let _78 := var_next_237
                    let expr_247 := _78
                    /// @src 0:1881:1892  "curr = next"
                    var_curr_223 := expr_247
                    let expr_248 := expr_247
                }
                /// @src 0:1919:1923  "curr"
                let _79 := var_curr_223
                let expr_252 := _79
                /// @src 0:1912:1923  "return curr"
                var__202 := expr_252
                leave

            }
            /// @src 0:58:1932  "contract AdvancedFeatures {..."

        }

        data ".metadata" hex"a2646970667358221220683440eed77eddf06cb420237aae43194a50c8813e867addbf3a8890b538524a64736f6c634300081e0033"
    }

}

