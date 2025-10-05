
/// @use-src 0:"test_validation/fixtures/solidity/Arithmetic.sol"
object "Arithmetic_165" {
    code {
        /// @src 0:57:1247  "contract Arithmetic {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        constructor_Arithmetic_165()

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("Arithmetic_165_deployed"), datasize("Arithmetic_165_deployed"))

        return(_1, datasize("Arithmetic_165_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:57:1247  "contract Arithmetic {..."
        function constructor_Arithmetic_165() {

            /// @src 0:57:1247  "contract Arithmetic {..."

        }
        /// @src 0:57:1247  "contract Arithmetic {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/Arithmetic.sol"
    object "Arithmetic_165_deployed" {
        code {
            /// @src 0:57:1247  "contract Arithmetic {..."
            mstore(64, memoryguard(128))

            if iszero(lt(calldatasize(), 4))
            {
                let selector := shift_right_224_unsigned(calldataload(0))
                switch selector

                case 0x165c4a16
                {
                    // multiply(uint256,uint256)

                    external_fun_multiply_50()
                }

                case 0x3ef5e445
                {
                    // subtract(uint256,uint256)

                    external_fun_subtract_36()
                }

                case 0x771602f7
                {
                    // add(uint256,uint256)

                    external_fun_add_15()
                }

                case 0xbaaf073d
                {
                    // modulo(uint256,uint256)

                    external_fun_modulo_92()
                }

                case 0xc04f01fc
                {
                    // power(uint256,uint256)

                    external_fun_power_130()
                }

                case 0xcba5477c
                {
                    // maximum(uint256,uint256)

                    external_fun_maximum_147()
                }

                case 0xdd2d2a12
                {
                    // minimum(uint256,uint256)

                    external_fun_minimum_164()
                }

                case 0xf88e9fbf
                {
                    // divide(uint256,uint256)

                    external_fun_divide_71()
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

            function external_fun_multiply_50() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1 :=  abi_decode_tuple_t_uint256t_uint256(4, calldatasize())
                let ret_0 :=  fun_multiply_50(param_0, param_1)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_subtract_36() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1 :=  abi_decode_tuple_t_uint256t_uint256(4, calldatasize())
                let ret_0 :=  fun_subtract_36(param_0, param_1)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_add_15() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1 :=  abi_decode_tuple_t_uint256t_uint256(4, calldatasize())
                let ret_0 :=  fun_add_15(param_0, param_1)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_modulo_92() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1 :=  abi_decode_tuple_t_uint256t_uint256(4, calldatasize())
                let ret_0 :=  fun_modulo_92(param_0, param_1)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_power_130() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1 :=  abi_decode_tuple_t_uint256t_uint256(4, calldatasize())
                let ret_0 :=  fun_power_130(param_0, param_1)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_maximum_147() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1 :=  abi_decode_tuple_t_uint256t_uint256(4, calldatasize())
                let ret_0 :=  fun_maximum_147(param_0, param_1)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_minimum_164() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1 :=  abi_decode_tuple_t_uint256t_uint256(4, calldatasize())
                let ret_0 :=  fun_minimum_164(param_0, param_1)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_divide_71() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1 :=  abi_decode_tuple_t_uint256t_uint256(4, calldatasize())
                let ret_0 :=  fun_divide_71(param_0, param_1)
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

            /// @ast-id 50
            /// @src 0:345:444  "function multiply(uint256 a, uint256 b) public pure returns (uint256) {..."
            function fun_multiply_50(var_a_38, var_b_40) -> var__43 {
                /// @src 0:406:413  "uint256"
                let zero_t_uint256_1 := zero_value_for_split_t_uint256()
                var__43 := zero_t_uint256_1

                /// @src 0:432:433  "a"
                let _2 := var_a_38
                let expr_45 := _2
                /// @src 0:436:437  "b"
                let _3 := var_b_40
                let expr_46 := _3
                /// @src 0:432:437  "a * b"
                let expr_47 := checked_mul_t_uint256(expr_45, expr_46)

                /// @src 0:425:437  "return a * b"
                var__43 := expr_47
                leave

            }
            /// @src 0:57:1247  "contract Arithmetic {..."

            function array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, length) -> updated_pos {
                mstore(pos, length)
                updated_pos := add(pos, 0x20)
            }

            function store_literal_in_memory_7a97ebf383abf4c53fcc964a2ec706b5269a2fc542785166f9071c05417dc99a(memPtr) {

                mstore(add(memPtr, 0), "Subtraction overflow")

            }

            function abi_encode_t_stringliteral_7a97ebf383abf4c53fcc964a2ec706b5269a2fc542785166f9071c05417dc99a_to_t_string_memory_ptr_fromStack(pos) -> end {
                pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 20)
                store_literal_in_memory_7a97ebf383abf4c53fcc964a2ec706b5269a2fc542785166f9071c05417dc99a(pos)
                end := add(pos, 32)
            }

            function abi_encode_tuple_t_stringliteral_7a97ebf383abf4c53fcc964a2ec706b5269a2fc542785166f9071c05417dc99a__to_t_string_memory_ptr__fromStack(headStart ) -> tail {
                tail := add(headStart, 32)

                mstore(add(headStart, 0), sub(tail, headStart))
                tail := abi_encode_t_stringliteral_7a97ebf383abf4c53fcc964a2ec706b5269a2fc542785166f9071c05417dc99a_to_t_string_memory_ptr_fromStack( tail)

            }

            function require_helper_t_stringliteral_7a97ebf383abf4c53fcc964a2ec706b5269a2fc542785166f9071c05417dc99a(condition ) {
                if iszero(condition)
                {

                    let memPtr := allocate_unbounded()

                    mstore(memPtr, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                    let end := abi_encode_tuple_t_stringliteral_7a97ebf383abf4c53fcc964a2ec706b5269a2fc542785166f9071c05417dc99a__to_t_string_memory_ptr__fromStack(add(memPtr, 4) )
                    revert(memPtr, sub(end, memPtr))
                }
            }

            function checked_sub_t_uint256(x, y) -> diff {
                x := cleanup_t_uint256(x)
                y := cleanup_t_uint256(y)
                diff := sub(x, y)

                if gt(diff, x) { panic_error_0x11() }

            }

            /// @ast-id 36
            /// @src 0:187:335  "function subtract(uint256 a, uint256 b) public pure returns (uint256) {..."
            function fun_subtract_36(var_a_17, var_b_19) -> var__22 {
                /// @src 0:248:255  "uint256"
                let zero_t_uint256_4 := zero_value_for_split_t_uint256()
                var__22 := zero_t_uint256_4

                /// @src 0:275:276  "b"
                let _5 := var_b_19
                let expr_25 := _5
                /// @src 0:280:281  "a"
                let _6 := var_a_17
                let expr_26 := _6
                /// @src 0:275:281  "b <= a"
                let expr_27 := iszero(gt(cleanup_t_uint256(expr_25), cleanup_t_uint256(expr_26)))
                /// @src 0:267:306  "require(b <= a, \"Subtraction overflow\")"
                require_helper_t_stringliteral_7a97ebf383abf4c53fcc964a2ec706b5269a2fc542785166f9071c05417dc99a(expr_27)
                /// @src 0:323:324  "a"
                let _7 := var_a_17
                let expr_31 := _7
                /// @src 0:327:328  "b"
                let _8 := var_b_19
                let expr_32 := _8
                /// @src 0:323:328  "a - b"
                let expr_33 := checked_sub_t_uint256(expr_31, expr_32)

                /// @src 0:316:328  "return a - b"
                var__22 := expr_33
                leave

            }
            /// @src 0:57:1247  "contract Arithmetic {..."

            function checked_add_t_uint256(x, y) -> sum {
                x := cleanup_t_uint256(x)
                y := cleanup_t_uint256(y)
                sum := add(x, y)

                if gt(x, sum) { panic_error_0x11() }

            }

            /// @ast-id 15
            /// @src 0:83:177  "function add(uint256 a, uint256 b) public pure returns (uint256) {..."
            function fun_add_15(var_a_3, var_b_5) -> var__8 {
                /// @src 0:139:146  "uint256"
                let zero_t_uint256_9 := zero_value_for_split_t_uint256()
                var__8 := zero_t_uint256_9

                /// @src 0:165:166  "a"
                let _10 := var_a_3
                let expr_10 := _10
                /// @src 0:169:170  "b"
                let _11 := var_b_5
                let expr_11 := _11
                /// @src 0:165:170  "a + b"
                let expr_12 := checked_add_t_uint256(expr_10, expr_11)

                /// @src 0:158:170  "return a + b"
                var__8 := expr_12
                leave

            }
            /// @src 0:57:1247  "contract Arithmetic {..."

            function cleanup_t_rational_0_by_1(value) -> cleaned {
                cleaned := value
            }

            function identity(value) -> ret {
                ret := value
            }

            function convert_t_rational_0_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_0_by_1(value)))
            }

            function store_literal_in_memory_5816d320aea84b87399d8e3a4b0ebd6946ce971e9e180f84036b6704c1c5ed0f(memPtr) {

                mstore(add(memPtr, 0), "Modulo by zero")

            }

            function abi_encode_t_stringliteral_5816d320aea84b87399d8e3a4b0ebd6946ce971e9e180f84036b6704c1c5ed0f_to_t_string_memory_ptr_fromStack(pos) -> end {
                pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 14)
                store_literal_in_memory_5816d320aea84b87399d8e3a4b0ebd6946ce971e9e180f84036b6704c1c5ed0f(pos)
                end := add(pos, 32)
            }

            function abi_encode_tuple_t_stringliteral_5816d320aea84b87399d8e3a4b0ebd6946ce971e9e180f84036b6704c1c5ed0f__to_t_string_memory_ptr__fromStack(headStart ) -> tail {
                tail := add(headStart, 32)

                mstore(add(headStart, 0), sub(tail, headStart))
                tail := abi_encode_t_stringliteral_5816d320aea84b87399d8e3a4b0ebd6946ce971e9e180f84036b6704c1c5ed0f_to_t_string_memory_ptr_fromStack( tail)

            }

            function require_helper_t_stringliteral_5816d320aea84b87399d8e3a4b0ebd6946ce971e9e180f84036b6704c1c5ed0f(condition ) {
                if iszero(condition)
                {

                    let memPtr := allocate_unbounded()

                    mstore(memPtr, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                    let end := abi_encode_tuple_t_stringliteral_5816d320aea84b87399d8e3a4b0ebd6946ce971e9e180f84036b6704c1c5ed0f__to_t_string_memory_ptr__fromStack(add(memPtr, 4) )
                    revert(memPtr, sub(end, memPtr))
                }
            }

            function panic_error_0x12() {
                mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                mstore(4, 0x12)
                revert(0, 0x24)
            }

            function mod_t_uint256(x, y) -> r {
                x := cleanup_t_uint256(x)
                y := cleanup_t_uint256(y)
                if iszero(y) { panic_error_0x12() }
                r := mod(x, y)
            }

            /// @ast-id 92
            /// @src 0:605:744  "function modulo(uint256 a, uint256 b) public pure returns (uint256) {..."
            function fun_modulo_92(var_a_73, var_b_75) -> var__78 {
                /// @src 0:664:671  "uint256"
                let zero_t_uint256_12 := zero_value_for_split_t_uint256()
                var__78 := zero_t_uint256_12

                /// @src 0:691:692  "b"
                let _13 := var_b_75
                let expr_81 := _13
                /// @src 0:695:696  "0"
                let expr_82 := 0x00
                /// @src 0:691:696  "b > 0"
                let expr_83 := gt(cleanup_t_uint256(expr_81), convert_t_rational_0_by_1_to_t_uint256(expr_82))
                /// @src 0:683:715  "require(b > 0, \"Modulo by zero\")"
                require_helper_t_stringliteral_5816d320aea84b87399d8e3a4b0ebd6946ce971e9e180f84036b6704c1c5ed0f(expr_83)
                /// @src 0:732:733  "a"
                let _14 := var_a_73
                let expr_87 := _14
                /// @src 0:736:737  "b"
                let _15 := var_b_75
                let expr_88 := _15
                /// @src 0:732:737  "a % b"
                let expr_89 := mod_t_uint256(expr_87, expr_88)

                /// @src 0:725:737  "return a % b"
                var__78 := expr_89
                leave

            }
            /// @src 0:57:1247  "contract Arithmetic {..."

            function cleanup_t_rational_1_by_1(value) -> cleaned {
                cleaned := value
            }

            function convert_t_rational_1_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_1_by_1(value)))
            }

            function increment_wrapping_t_uint256(value) -> ret {
                ret := cleanup_t_uint256(add(value, 1))
            }

            /// @ast-id 130
            /// @src 0:754:1013  "function power(uint256 base, uint256 exponent) public pure returns (uint256) {..."
            function fun_power_130(var_base_94, var_exponent_96) -> var__99 {
                /// @src 0:822:829  "uint256"
                let zero_t_uint256_16 := zero_value_for_split_t_uint256()
                var__99 := zero_t_uint256_16

                /// @src 0:845:853  "exponent"
                let _17 := var_exponent_96
                let expr_101 := _17
                /// @src 0:857:858  "0"
                let expr_102 := 0x00
                /// @src 0:845:858  "exponent == 0"
                let expr_103 := eq(cleanup_t_uint256(expr_101), convert_t_rational_0_by_1_to_t_uint256(expr_102))
                /// @src 0:841:868  "if (exponent == 0) return 1"
                if expr_103 {
                    /// @src 0:867:868  "1"
                    let expr_104 := 0x01
                    /// @src 0:860:868  "return 1"
                    var__99 := convert_t_rational_1_by_1_to_t_uint256(expr_104)
                    leave
                    /// @src 0:841:868  "if (exponent == 0) return 1"
                }
                /// @src 0:895:896  "1"
                let expr_109 := 0x01
                /// @src 0:878:896  "uint256 result = 1"
                let var_result_108 := convert_t_rational_1_by_1_to_t_uint256(expr_109)
                /// @src 0:906:984  "for (uint256 i = 0; i < exponent; i++) {..."
                for {
                    /// @src 0:923:924  "0"
                    let expr_113 := 0x00
                    /// @src 0:911:924  "uint256 i = 0"
                    let var_i_112 := convert_t_rational_0_by_1_to_t_uint256(expr_113)
                    } 1 {
                    /// @src 0:940:943  "i++"
                    let _19 := var_i_112
                    let _18 := increment_wrapping_t_uint256(_19)
                    var_i_112 := _18
                    let expr_119 := _19
                }
                {
                    /// @src 0:926:927  "i"
                    let _20 := var_i_112
                    let expr_115 := _20
                    /// @src 0:930:938  "exponent"
                    let _21 := var_exponent_96
                    let expr_116 := _21
                    /// @src 0:926:938  "i < exponent"
                    let expr_117 := lt(cleanup_t_uint256(expr_115), cleanup_t_uint256(expr_116))
                    if iszero(expr_117) { break }
                    /// @src 0:969:973  "base"
                    let _22 := var_base_94
                    let expr_122 := _22
                    /// @src 0:959:973  "result *= base"
                    let _23 := var_result_108
                    let expr_123 := checked_mul_t_uint256(_23, expr_122)

                    var_result_108 := expr_123
                }
                /// @src 0:1000:1006  "result"
                let _24 := var_result_108
                let expr_127 := _24
                /// @src 0:993:1006  "return result"
                var__99 := expr_127
                leave

            }
            /// @src 0:57:1247  "contract Arithmetic {..."

            /// @ast-id 147
            /// @src 0:1023:1129  "function maximum(uint256 a, uint256 b) public pure returns (uint256) {..."
            function fun_maximum_147(var_a_132, var_b_134) -> var__137 {
                /// @src 0:1083:1090  "uint256"
                let zero_t_uint256_25 := zero_value_for_split_t_uint256()
                var__137 := zero_t_uint256_25

                /// @src 0:1109:1110  "a"
                let _26 := var_a_132
                let expr_139 := _26
                /// @src 0:1113:1114  "b"
                let _27 := var_b_134
                let expr_140 := _27
                /// @src 0:1109:1114  "a > b"
                let expr_141 := gt(cleanup_t_uint256(expr_139), cleanup_t_uint256(expr_140))
                /// @src 0:1109:1122  "a > b ? a : b"
                let expr_144
                switch expr_141
                case 0 {
                    /// @src 0:1121:1122  "b"
                    let _28 := var_b_134
                    let expr_143 := _28
                    /// @src 0:1109:1122  "a > b ? a : b"
                    expr_144 := expr_143
                }
                default {
                    /// @src 0:1117:1118  "a"
                    let _29 := var_a_132
                    let expr_142 := _29
                    /// @src 0:1109:1122  "a > b ? a : b"
                    expr_144 := expr_142
                }
                /// @src 0:1102:1122  "return a > b ? a : b"
                var__137 := expr_144
                leave

            }
            /// @src 0:57:1247  "contract Arithmetic {..."

            /// @ast-id 164
            /// @src 0:1139:1245  "function minimum(uint256 a, uint256 b) public pure returns (uint256) {..."
            function fun_minimum_164(var_a_149, var_b_151) -> var__154 {
                /// @src 0:1199:1206  "uint256"
                let zero_t_uint256_30 := zero_value_for_split_t_uint256()
                var__154 := zero_t_uint256_30

                /// @src 0:1225:1226  "a"
                let _31 := var_a_149
                let expr_156 := _31
                /// @src 0:1229:1230  "b"
                let _32 := var_b_151
                let expr_157 := _32
                /// @src 0:1225:1230  "a < b"
                let expr_158 := lt(cleanup_t_uint256(expr_156), cleanup_t_uint256(expr_157))
                /// @src 0:1225:1238  "a < b ? a : b"
                let expr_161
                switch expr_158
                case 0 {
                    /// @src 0:1237:1238  "b"
                    let _33 := var_b_151
                    let expr_160 := _33
                    /// @src 0:1225:1238  "a < b ? a : b"
                    expr_161 := expr_160
                }
                default {
                    /// @src 0:1233:1234  "a"
                    let _34 := var_a_149
                    let expr_159 := _34
                    /// @src 0:1225:1238  "a < b ? a : b"
                    expr_161 := expr_159
                }
                /// @src 0:1218:1238  "return a < b ? a : b"
                var__154 := expr_161
                leave

            }
            /// @src 0:57:1247  "contract Arithmetic {..."

            function store_literal_in_memory_968e8a9596f7536bebaa1dc35ec1b8ce462e72aa79d0d2852a644435cad20b58(memPtr) {

                mstore(add(memPtr, 0), "Division by zero")

            }

            function abi_encode_t_stringliteral_968e8a9596f7536bebaa1dc35ec1b8ce462e72aa79d0d2852a644435cad20b58_to_t_string_memory_ptr_fromStack(pos) -> end {
                pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 16)
                store_literal_in_memory_968e8a9596f7536bebaa1dc35ec1b8ce462e72aa79d0d2852a644435cad20b58(pos)
                end := add(pos, 32)
            }

            function abi_encode_tuple_t_stringliteral_968e8a9596f7536bebaa1dc35ec1b8ce462e72aa79d0d2852a644435cad20b58__to_t_string_memory_ptr__fromStack(headStart ) -> tail {
                tail := add(headStart, 32)

                mstore(add(headStart, 0), sub(tail, headStart))
                tail := abi_encode_t_stringliteral_968e8a9596f7536bebaa1dc35ec1b8ce462e72aa79d0d2852a644435cad20b58_to_t_string_memory_ptr_fromStack( tail)

            }

            function require_helper_t_stringliteral_968e8a9596f7536bebaa1dc35ec1b8ce462e72aa79d0d2852a644435cad20b58(condition ) {
                if iszero(condition)
                {

                    let memPtr := allocate_unbounded()

                    mstore(memPtr, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                    let end := abi_encode_tuple_t_stringliteral_968e8a9596f7536bebaa1dc35ec1b8ce462e72aa79d0d2852a644435cad20b58__to_t_string_memory_ptr__fromStack(add(memPtr, 4) )
                    revert(memPtr, sub(end, memPtr))
                }
            }

            function checked_div_t_uint256(x, y) -> r {
                x := cleanup_t_uint256(x)
                y := cleanup_t_uint256(y)
                if iszero(y) { panic_error_0x12() }

                r := div(x, y)
            }

            /// @ast-id 71
            /// @src 0:454:595  "function divide(uint256 a, uint256 b) public pure returns (uint256) {..."
            function fun_divide_71(var_a_52, var_b_54) -> var__57 {
                /// @src 0:513:520  "uint256"
                let zero_t_uint256_35 := zero_value_for_split_t_uint256()
                var__57 := zero_t_uint256_35

                /// @src 0:540:541  "b"
                let _36 := var_b_54
                let expr_60 := _36
                /// @src 0:544:545  "0"
                let expr_61 := 0x00
                /// @src 0:540:545  "b > 0"
                let expr_62 := gt(cleanup_t_uint256(expr_60), convert_t_rational_0_by_1_to_t_uint256(expr_61))
                /// @src 0:532:566  "require(b > 0, \"Division by zero\")"
                require_helper_t_stringliteral_968e8a9596f7536bebaa1dc35ec1b8ce462e72aa79d0d2852a644435cad20b58(expr_62)
                /// @src 0:583:584  "a"
                let _37 := var_a_52
                let expr_66 := _37
                /// @src 0:587:588  "b"
                let _38 := var_b_54
                let expr_67 := _38
                /// @src 0:583:588  "a / b"
                let expr_68 := checked_div_t_uint256(expr_66, expr_67)

                /// @src 0:576:588  "return a / b"
                var__57 := expr_68
                leave

            }
            /// @src 0:57:1247  "contract Arithmetic {..."

        }

        data ".metadata" hex"a2646970667358221220f314d9f60dd9b92fa328a3b4b007d8d40e219089d876a6f0fed52b91a596d4a564736f6c634300081e0033"
    }

}

