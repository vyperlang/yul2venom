/// @use-src 0:"test_validation/fixtures/solidity/AdvancedFeatures.sol"
object "AdvancedFeatures_257" {
    code {
        /// @src 0:213:2087  "contract AdvancedFeatures {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        constructor_AdvancedFeatures_257()

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("AdvancedFeatures_257_deployed"), datasize("AdvancedFeatures_257_deployed"))

        return(_1, datasize("AdvancedFeatures_257_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:213:2087  "contract AdvancedFeatures {..."
        function constructor_AdvancedFeatures_257() {

            /// @src 0:213:2087  "contract AdvancedFeatures {..."

        }
        /// @src 0:213:2087  "contract AdvancedFeatures {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/AdvancedFeatures.sol"
    object "AdvancedFeatures_257_deployed" {
        code {
            /// @src 0:213:2087  "contract AdvancedFeatures {..."
            mstore(64, memoryguard(128))

            if iszero(lt(calldatasize(), 4))
            {
                let selector := shift_right_224_unsigned(calldataload(0))
                switch selector

                case 0x2e1a7d4d
                {
                    // withdraw(uint256)

                    external_fun_withdraw_84()
                }

                case 0x6f77926b
                {
                    // getUser(address)

                    external_fun_getUser_107()
                }

                case 0x7649c433
                {
                    // historyAverage()

                    external_fun_historyAverage_161()
                }

                case 0x83714834
                {
                    // factorial(uint256)

                    external_fun_factorial_198()
                }

                case 0xb6b55f25
                {
                    // deposit(uint256)

                    external_fun_deposit_50()
                }

                case 0xc557abe6
                {
                    // historySum()

                    external_fun_historySum_138()
                }

                case 0xc6c2ea17
                {
                    // fib(uint256)

                    external_fun_fib_256()
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

            function external_fun_withdraw_84() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                fun_withdraw_84(param_0)
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

            function external_fun_getUser_107() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_address(4, calldatasize())
                let ret_0, ret_1 :=  fun_getUser_107(param_0)
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

            function external_fun_historyAverage_161() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                abi_decode_tuple_(4, calldatasize())
                let ret_0 :=  fun_historyAverage_161()
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_factorial_198() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                let ret_0 :=  fun_factorial_198(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_deposit_50() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                fun_deposit_50(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple__to__fromStack(memPos  )
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_historySum_138() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                abi_decode_tuple_(4, calldatasize())
                let ret_0 :=  fun_historySum_138()
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_fib_256() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                let ret_0 :=  fun_fib_256(param_0)
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

            function mapping_index_access_t_mapping$_t_address_$_t_struct$_User_$7_storage_$_of_t_address(slot , key) -> dataSlot {
                mstore(0, convert_t_address_to_t_address(key))
                mstore(0x20, slot)
                dataSlot := keccak256(0, 0x40)
            }

            function convert_t_struct$_User_$7_storage_to_t_struct$_User_$7_storage_ptr(value) -> converted {
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

            /// @ast-id 84
            /// @src 0:614:828  "function withdraw(uint256 amount) public {..."
            function fun_withdraw_84(var_amount_52) {

                /// @src 0:685:690  "users"
                let _1_slot := 0x00
                let expr_58_slot := _1_slot
                /// @src 0:691:701  "msg.sender"
                let expr_60 := caller()
                /// @src 0:685:702  "users[msg.sender]"
                let _2 := mapping_index_access_t_mapping$_t_address_$_t_struct$_User_$7_storage_$_of_t_address(expr_58_slot,expr_60)
                let _3_slot := _2
                let expr_61_slot := _3_slot
                /// @src 0:665:702  "User storage user = users[msg.sender]"
                let var_user_57_slot := convert_t_struct$_User_$7_storage_to_t_struct$_User_$7_storage_ptr(expr_61_slot)
                /// @src 0:720:724  "user"
                let _4_slot := var_user_57_slot
                let expr_64_slot := _4_slot
                /// @src 0:720:732  "user.balance"
                let _5 := add(expr_64_slot, 0)
                let _6 := read_from_storage_split_offset_0_t_uint256(_5)
                let expr_65 := _6
                /// @src 0:736:742  "amount"
                let _7 := var_amount_52
                let expr_66 := _7
                /// @src 0:720:742  "user.balance >= amount"
                let expr_67 := iszero(lt(cleanup_t_uint256(expr_65), cleanup_t_uint256(expr_66)))
                /// @src 0:712:759  "require(user.balance >= amount, \"insufficient\")"
                require_helper_t_stringliteral_1d6424f41c888659cfd6cfa52fead9c914e6f8687116697f5c9ecb1e5532665d(expr_67)
                /// @src 0:785:791  "amount"
                let _8 := var_amount_52
                let expr_74 := _8
                /// @src 0:769:773  "user"
                let _9_slot := var_user_57_slot
                let expr_71_slot := _9_slot
                /// @src 0:769:781  "user.balance"
                let _10 := add(expr_71_slot, 0)
                /// @src 0:769:791  "user.balance -= amount"
                let _11 := read_from_storage_split_offset_0_t_uint256(_10)
                let expr_75 := checked_sub_t_uint256(_11, expr_74)

                update_storage_value_offset_0_t_uint256_to_t_uint256(_10, expr_75)
                /// @src 0:820:821  "1"
                let expr_80 := 0x01
                /// @src 0:801:821  "user.operations += 1"
                let _12 := convert_t_rational_1_by_1_to_t_uint256(expr_80)
                /// @src 0:801:805  "user"
                let _13_slot := var_user_57_slot
                let expr_77_slot := _13_slot
                /// @src 0:801:816  "user.operations"
                let _14 := add(expr_77_slot, 1)
                /// @src 0:801:821  "user.operations += 1"
                let _15 := read_from_storage_split_offset_0_t_uint256(_14)
                let expr_81 := checked_add_t_uint256(_15, _12)

                update_storage_value_offset_0_t_uint256_to_t_uint256(_14, expr_81)

            }
            /// @src 0:213:2087  "contract AdvancedFeatures {..."

            function zero_value_for_split_t_uint256() -> ret {
                ret := 0
            }

            /// @ast-id 107
            /// @src 0:834:1025  "function getUser(address account) public view returns (uint256 balance, uint256 operations) {..."
            function fun_getUser_107(var_account_86) -> var_balance_89, var_operations_91 {
                /// @src 0:889:904  "uint256 balance"
                let zero_t_uint256_16 := zero_value_for_split_t_uint256()
                var_balance_89 := zero_t_uint256_16
                /// @src 0:906:924  "uint256 operations"
                let zero_t_uint256_17 := zero_value_for_split_t_uint256()
                var_operations_91 := zero_t_uint256_17

                /// @src 0:956:961  "users"
                let _18_slot := 0x00
                let expr_96_slot := _18_slot
                /// @src 0:962:969  "account"
                let _19 := var_account_86
                let expr_97 := _19
                /// @src 0:956:970  "users[account]"
                let _20 := mapping_index_access_t_mapping$_t_address_$_t_struct$_User_$7_storage_$_of_t_address(expr_96_slot,expr_97)
                let _21_slot := _20
                let expr_98_slot := _21_slot
                /// @src 0:936:970  "User storage user = users[account]"
                let var_user_95_slot := convert_t_struct$_User_$7_storage_to_t_struct$_User_$7_storage_ptr(expr_98_slot)
                /// @src 0:988:992  "user"
                let _22_slot := var_user_95_slot
                let expr_100_slot := _22_slot
                /// @src 0:988:1000  "user.balance"
                let _23 := add(expr_100_slot, 0)
                let _24 := read_from_storage_split_offset_0_t_uint256(_23)
                let expr_101 := _24
                /// @src 0:987:1018  "(user.balance, user.operations)"
                let expr_104_component_1 := expr_101
                /// @src 0:1002:1006  "user"
                let _25_slot := var_user_95_slot
                let expr_102_slot := _25_slot
                /// @src 0:1002:1017  "user.operations"
                let _26 := add(expr_102_slot, 1)
                let _27 := read_from_storage_split_offset_0_t_uint256(_26)
                let expr_103 := _27
                /// @src 0:987:1018  "(user.balance, user.operations)"
                let expr_104_component_2 := expr_103
                /// @src 0:980:1018  "return (user.balance, user.operations)"
                var_balance_89 := expr_104_component_1
                var_operations_91 := expr_104_component_2
                leave

            }
            /// @src 0:213:2087  "contract AdvancedFeatures {..."

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

            /// @ast-id 161
            /// @src 0:1237:1438  "function historyAverage() public view returns (uint256) {..."
            function fun_historyAverage_161() -> var__141 {
                /// @src 0:1284:1291  "uint256"
                let zero_t_uint256_28 := zero_value_for_split_t_uint256()
                var__141 := zero_t_uint256_28

                /// @src 0:1320:1327  "history"
                let _29_slot := 0x01
                let expr_145_slot := _29_slot
                /// @src 0:1320:1334  "history.length"
                let expr_146 := array_length_t_array$_t_uint256_$dyn_storage(expr_145_slot)
                /// @src 0:1303:1334  "uint256 length = history.length"
                let var_length_144 := expr_146
                /// @src 0:1348:1354  "length"
                let _30 := var_length_144
                let expr_148 := _30
                /// @src 0:1358:1359  "0"
                let expr_149 := 0x00
                /// @src 0:1348:1359  "length == 0"
                let expr_150 := eq(cleanup_t_uint256(expr_148), convert_t_rational_0_by_1_to_t_uint256(expr_149))
                /// @src 0:1344:1394  "if (length == 0) {..."
                if expr_150 {
                    /// @src 0:1382:1383  "0"
                    let expr_151 := 0x00
                    /// @src 0:1375:1383  "return 0"
                    var__141 := convert_t_rational_0_by_1_to_t_uint256(expr_151)
                    leave
                    /// @src 0:1344:1394  "if (length == 0) {..."
                }
                /// @src 0:1410:1422  "historySum()"
                let expr_156 := fun_historySum_138()
                /// @src 0:1425:1431  "length"
                let _31 := var_length_144
                let expr_157 := _31
                /// @src 0:1410:1431  "historySum() / length"
                let expr_158 := checked_div_t_uint256(expr_156, expr_157)

                /// @src 0:1403:1431  "return historySum() / length"
                var__141 := expr_158
                leave

            }
            /// @src 0:213:2087  "contract AdvancedFeatures {..."

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

            /// @ast-id 198
            /// @src 0:1444:1694  "function factorial(uint256 n) public pure returns (uint256) {..."
            function fun_factorial_198(var_n_163) -> var__166 {
                /// @src 0:1495:1502  "uint256"
                let zero_t_uint256_32 := zero_value_for_split_t_uint256()
                var__166 := zero_t_uint256_32

                /// @src 0:1518:1519  "n"
                let _33 := var_n_163
                let expr_168 := _33
                /// @src 0:1523:1524  "0"
                let expr_169 := 0x00
                /// @src 0:1518:1524  "n == 0"
                let expr_170 := eq(cleanup_t_uint256(expr_168), convert_t_rational_0_by_1_to_t_uint256(expr_169))
                /// @src 0:1514:1559  "if (n == 0) {..."
                if expr_170 {
                    /// @src 0:1547:1548  "1"
                    let expr_171 := 0x01
                    /// @src 0:1540:1548  "return 1"
                    var__166 := convert_t_rational_1_by_1_to_t_uint256(expr_171)
                    leave
                    /// @src 0:1514:1559  "if (n == 0) {..."
                }
                /// @src 0:1585:1586  "1"
                let expr_177 := 0x01
                /// @src 0:1568:1586  "uint256 result = 1"
                let var_result_176 := convert_t_rational_1_by_1_to_t_uint256(expr_177)
                /// @src 0:1596:1665  "for (uint256 i = 2; i <= n; i++) {..."
                for {
                    /// @src 0:1613:1614  "2"
                    let expr_181 := 0x02
                    /// @src 0:1601:1614  "uint256 i = 2"
                    let var_i_180 := convert_t_rational_2_by_1_to_t_uint256(expr_181)
                    } 1 {
                    /// @src 0:1624:1627  "i++"
                    let _35 := var_i_180
                    let _34 := increment_t_uint256(_35)
                    var_i_180 := _34
                    let expr_187 := _35
                }
                {
                    /// @src 0:1616:1617  "i"
                    let _36 := var_i_180
                    let expr_183 := _36
                    /// @src 0:1621:1622  "n"
                    let _37 := var_n_163
                    let expr_184 := _37
                    /// @src 0:1616:1622  "i <= n"
                    let expr_185 := iszero(gt(cleanup_t_uint256(expr_183), cleanup_t_uint256(expr_184)))
                    if iszero(expr_185) { break }
                    /// @src 0:1653:1654  "i"
                    let _38 := var_i_180
                    let expr_190 := _38
                    /// @src 0:1643:1654  "result *= i"
                    let _39 := var_result_176
                    let expr_191 := checked_mul_t_uint256(_39, expr_190)

                    var_result_176 := expr_191
                }
                /// @src 0:1681:1687  "result"
                let _40 := var_result_176
                let expr_195 := _40
                /// @src 0:1674:1687  "return result"
                var__166 := expr_195
                leave

            }
            /// @src 0:213:2087  "contract AdvancedFeatures {..."

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
            /// @ast-id 50
            /// @src 0:399:608  "function deposit(uint256 amount) public {..."
            function fun_deposit_50(var_amount_17) {

                /// @src 0:457:463  "amount"
                let _41 := var_amount_17
                let expr_21 := _41
                /// @src 0:466:467  "0"
                let expr_22 := 0x00
                /// @src 0:457:467  "amount > 0"
                let expr_23 := gt(cleanup_t_uint256(expr_21), convert_t_rational_0_by_1_to_t_uint256(expr_22))
                /// @src 0:449:483  "require(amount > 0, \"amount zero\")"
                require_helper_t_stringliteral_7a4b27aca3817e208aeec5219b8023ae68f7f4a75daa22a4be89e1a2b2c69b92(expr_23)
                /// @src 0:522:528  "amount"
                let _42 := var_amount_17
                let expr_32 := _42
                /// @src 0:493:498  "users"
                let _43_slot := 0x00
                let expr_27_slot := _43_slot
                /// @src 0:499:509  "msg.sender"
                let expr_29 := caller()
                /// @src 0:493:510  "users[msg.sender]"
                let _44 := mapping_index_access_t_mapping$_t_address_$_t_struct$_User_$7_storage_$_of_t_address(expr_27_slot,expr_29)
                let _45_slot := _44
                let expr_30_slot := _45_slot
                /// @src 0:493:518  "users[msg.sender].balance"
                let _46 := add(expr_30_slot, 0)
                /// @src 0:493:528  "users[msg.sender].balance += amount"
                let _47 := read_from_storage_split_offset_0_t_uint256(_46)
                let expr_33 := checked_add_t_uint256(_47, expr_32)

                update_storage_value_offset_0_t_uint256_to_t_uint256(_46, expr_33)
                /// @src 0:570:571  "1"
                let expr_40 := 0x01
                /// @src 0:538:571  "users[msg.sender].operations += 1"
                let _48 := convert_t_rational_1_by_1_to_t_uint256(expr_40)
                /// @src 0:538:543  "users"
                let _49_slot := 0x00
                let expr_35_slot := _49_slot
                /// @src 0:544:554  "msg.sender"
                let expr_37 := caller()
                /// @src 0:538:555  "users[msg.sender]"
                let _50 := mapping_index_access_t_mapping$_t_address_$_t_struct$_User_$7_storage_$_of_t_address(expr_35_slot,expr_37)
                let _51_slot := _50
                let expr_38_slot := _51_slot
                /// @src 0:538:566  "users[msg.sender].operations"
                let _52 := add(expr_38_slot, 1)
                /// @src 0:538:571  "users[msg.sender].operations += 1"
                let _53 := read_from_storage_split_offset_0_t_uint256(_52)
                let expr_41 := checked_add_t_uint256(_53, _48)

                update_storage_value_offset_0_t_uint256_to_t_uint256(_52, expr_41)
                /// @src 0:581:588  "history"
                let _54_slot := 0x01
                let expr_43_slot := _54_slot
                /// @src 0:581:593  "history.push"
                let expr_45_self_slot := convert_array_t_array$_t_uint256_$dyn_storage_to_t_array$_t_uint256_$dyn_storage_ptr(expr_43_slot)
                /// @src 0:594:600  "amount"
                let _55 := var_amount_17
                let expr_46 := _55
                /// @src 0:581:601  "history.push(amount)"
                array_push_from_t_uint256_to_t_array$_t_uint256_$dyn_storage_ptr(expr_45_self_slot, expr_46)

            }
            /// @src 0:213:2087  "contract AdvancedFeatures {..."

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

            /// @ast-id 138
            /// @src 0:1031:1231  "function historySum() public view returns (uint256) {..."
            function fun_historySum_138() -> var__110 {
                /// @src 0:1074:1081  "uint256"
                let zero_t_uint256_56 := zero_value_for_split_t_uint256()
                var__110 := zero_t_uint256_56

                /// @src 0:1107:1108  "0"
                let expr_114 := 0x00
                /// @src 0:1093:1108  "uint256 sum = 0"
                let var_sum_113 := convert_t_rational_0_by_1_to_t_uint256(expr_114)
                /// @src 0:1118:1205  "for (uint256 i = 0; i < history.length; i++) {..."
                for {
                    /// @src 0:1135:1136  "0"
                    let expr_118 := 0x00
                    /// @src 0:1123:1136  "uint256 i = 0"
                    let var_i_117 := convert_t_rational_0_by_1_to_t_uint256(expr_118)
                    } 1 {
                    /// @src 0:1158:1161  "i++"
                    let _58 := var_i_117
                    let _57 := increment_wrapping_t_uint256(_58)
                    var_i_117 := _57
                    let expr_125 := _58
                }
                {
                    /// @src 0:1138:1139  "i"
                    let _59 := var_i_117
                    let expr_120 := _59
                    /// @src 0:1142:1149  "history"
                    let _60_slot := 0x01
                    let expr_121_slot := _60_slot
                    /// @src 0:1142:1156  "history.length"
                    let expr_122 := array_length_t_array$_t_uint256_$dyn_storage(expr_121_slot)
                    /// @src 0:1138:1156  "i < history.length"
                    let expr_123 := lt(cleanup_t_uint256(expr_120), cleanup_t_uint256(expr_122))
                    if iszero(expr_123) { break }
                    /// @src 0:1184:1191  "history"
                    let _61_slot := 0x01
                    let expr_128_slot := _61_slot
                    /// @src 0:1192:1193  "i"
                    let _62 := var_i_117
                    let expr_129 := _62
                    /// @src 0:1184:1194  "history[i]"

                    let _63, _64 := storage_array_index_access_t_array$_t_uint256_$dyn_storage(expr_128_slot, expr_129)
                    let _65 := read_from_storage_split_dynamic_t_uint256(_63, _64)
                    let expr_130 := _65
                    /// @src 0:1177:1194  "sum += history[i]"
                    let _66 := var_sum_113
                    let expr_131 := checked_add_t_uint256(_66, expr_130)

                    var_sum_113 := expr_131
                }
                /// @src 0:1221:1224  "sum"
                let _67 := var_sum_113
                let expr_135 := _67
                /// @src 0:1214:1224  "return sum"
                var__110 := expr_135
                leave

            }
            /// @src 0:213:2087  "contract AdvancedFeatures {..."

            /// @ast-id 256
            /// @src 0:1700:2085  "function fib(uint256 n) public pure returns (uint256) {..."
            function fun_fib_256(var_n_200) -> var__203 {
                /// @src 0:1745:1752  "uint256"
                let zero_t_uint256_68 := zero_value_for_split_t_uint256()
                var__203 := zero_t_uint256_68

                /// @src 0:1768:1769  "n"
                let _69 := var_n_200
                let expr_205 := _69
                /// @src 0:1773:1774  "0"
                let expr_206 := 0x00
                /// @src 0:1768:1774  "n == 0"
                let expr_207 := eq(cleanup_t_uint256(expr_205), convert_t_rational_0_by_1_to_t_uint256(expr_206))
                /// @src 0:1764:1809  "if (n == 0) {..."
                if expr_207 {
                    /// @src 0:1797:1798  "0"
                    let expr_208 := 0x00
                    /// @src 0:1790:1798  "return 0"
                    var__203 := convert_t_rational_0_by_1_to_t_uint256(expr_208)
                    leave
                    /// @src 0:1764:1809  "if (n == 0) {..."
                }
                /// @src 0:1822:1823  "n"
                let _70 := var_n_200
                let expr_212 := _70
                /// @src 0:1827:1828  "1"
                let expr_213 := 0x01
                /// @src 0:1822:1828  "n == 1"
                let expr_214 := eq(cleanup_t_uint256(expr_212), convert_t_rational_1_by_1_to_t_uint256(expr_213))
                /// @src 0:1818:1863  "if (n == 1) {..."
                if expr_214 {
                    /// @src 0:1851:1852  "1"
                    let expr_215 := 0x01
                    /// @src 0:1844:1852  "return 1"
                    var__203 := convert_t_rational_1_by_1_to_t_uint256(expr_215)
                    leave
                    /// @src 0:1818:1863  "if (n == 1) {..."
                }
                /// @src 0:1887:1888  "0"
                let expr_221 := 0x00
                /// @src 0:1872:1888  "uint256 prev = 0"
                let var_prev_220 := convert_t_rational_0_by_1_to_t_uint256(expr_221)
                /// @src 0:1913:1914  "1"
                let expr_225 := 0x01
                /// @src 0:1898:1914  "uint256 curr = 1"
                let var_curr_224 := convert_t_rational_1_by_1_to_t_uint256(expr_225)
                /// @src 0:1924:2058  "for (uint256 i = 2; i <= n; i++) {..."
                for {
                    /// @src 0:1941:1942  "2"
                    let expr_229 := 0x02
                    /// @src 0:1929:1942  "uint256 i = 2"
                    let var_i_228 := convert_t_rational_2_by_1_to_t_uint256(expr_229)
                    } 1 {
                    /// @src 0:1952:1955  "i++"
                    let _72 := var_i_228
                    let _71 := increment_t_uint256(_72)
                    var_i_228 := _71
                    let expr_235 := _72
                }
                {
                    /// @src 0:1944:1945  "i"
                    let _73 := var_i_228
                    let expr_231 := _73
                    /// @src 0:1949:1950  "n"
                    let _74 := var_n_200
                    let expr_232 := _74
                    /// @src 0:1944:1950  "i <= n"
                    let expr_233 := iszero(gt(cleanup_t_uint256(expr_231), cleanup_t_uint256(expr_232)))
                    if iszero(expr_233) { break }
                    /// @src 0:1986:1990  "prev"
                    let _75 := var_prev_220
                    let expr_239 := _75
                    /// @src 0:1993:1997  "curr"
                    let _76 := var_curr_224
                    let expr_240 := _76
                    /// @src 0:1986:1997  "prev + curr"
                    let expr_241 := checked_add_t_uint256(expr_239, expr_240)

                    /// @src 0:1971:1997  "uint256 next = prev + curr"
                    let var_next_238 := expr_241
                    /// @src 0:2018:2022  "curr"
                    let _77 := var_curr_224
                    let expr_244 := _77
                    /// @src 0:2011:2022  "prev = curr"
                    var_prev_220 := expr_244
                    let expr_245 := expr_244
                    /// @src 0:2043:2047  "next"
                    let _78 := var_next_238
                    let expr_248 := _78
                    /// @src 0:2036:2047  "curr = next"
                    var_curr_224 := expr_248
                    let expr_249 := expr_248
                }
                /// @src 0:2074:2078  "curr"
                let _79 := var_curr_224
                let expr_253 := _79
                /// @src 0:2067:2078  "return curr"
                var__203 := expr_253
                leave

            }
            /// @src 0:213:2087  "contract AdvancedFeatures {..."

        }

        data ".metadata" hex"a2646970667358221220d9234466089156ffcebf416f912754c3508f24a3e34c1530b890eea92bac1a5a64736f6c634300081e0033"
    }

}