
/// @use-src 0:"test_validation/fixtures/solidity/HeavyMath.sol"
object "HeavyMath_367" {
    code {
        /// @src 0:58:2373  "contract HeavyMath {..."
        mstore(64, memoryguard(128))
        if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }

        constructor_HeavyMath_367()

        let _1 := allocate_unbounded()
        codecopy(_1, dataoffset("HeavyMath_367_deployed"), datasize("HeavyMath_367_deployed"))

        return(_1, datasize("HeavyMath_367_deployed"))

        function allocate_unbounded() -> memPtr {
            memPtr := mload(64)
        }

        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() {
            revert(0, 0)
        }

        /// @src 0:58:2373  "contract HeavyMath {..."
        function constructor_HeavyMath_367() {

            /// @src 0:58:2373  "contract HeavyMath {..."

        }
        /// @src 0:58:2373  "contract HeavyMath {..."

    }
    /// @use-src 0:"test_validation/fixtures/solidity/HeavyMath.sol"
    object "HeavyMath_367_deployed" {
        code {
            /// @src 0:58:2373  "contract HeavyMath {..."
            mstore(64, memoryguard(128))

            if iszero(lt(calldatasize(), 4))
            {
                let selector := shift_right_224_unsigned(calldataload(0))
                switch selector

                case 0x0359fb28
                {
                    // polynomialReduce(uint256)

                    external_fun_polynomialReduce_179()
                }

                case 0x520f3971
                {
                    // sumOfSquares(uint256)

                    external_fun_sumOfSquares_30()
                }

                case 0x61047ff4
                {
                    // fibonacci(uint256)

                    external_fun_fibonacci_124()
                }

                case 0x751d6ff9
                {
                    // mixedSeries(uint256,uint256)

                    external_fun_mixedSeries_251()
                }

                case 0xd542942c
                {
                    // factorialMod(uint256)

                    external_fun_factorialMod_70()
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

            function external_fun_polynomialReduce_179() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                let ret_0 :=  fun_polynomialReduce_179(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_sumOfSquares_30() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                let ret_0 :=  fun_sumOfSquares_30(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_fibonacci_124() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                let ret_0 :=  fun_fibonacci_124(param_0)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

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

            function external_fun_mixedSeries_251() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0, param_1 :=  abi_decode_tuple_t_uint256t_uint256(4, calldatasize())
                let ret_0 :=  fun_mixedSeries_251(param_0, param_1)
                let memPos := allocate_unbounded()
                let memEnd := abi_encode_tuple_t_uint256__to_t_uint256__fromStack(memPos , ret_0)
                return(memPos, sub(memEnd, memPos))

            }

            function external_fun_factorialMod_70() {

                if callvalue() { revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb() }
                let param_0 :=  abi_decode_tuple_t_uint256(4, calldatasize())
                let ret_0 :=  fun_factorialMod_70(param_0)
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

            function identity(value) -> ret {
                ret := value
            }

            function convert_t_rational_0_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_0_by_1(value)))
            }

            function increment_wrapping_t_uint256(value) -> ret {
                ret := cleanup_t_uint256(add(value, 1))
            }

            function cleanup_t_rational_64_by_1(value) -> cleaned {
                cleaned := value
            }

            function convert_t_rational_64_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_64_by_1(value)))
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

            function cleanup_t_rational_2_by_1(value) -> cleaned {
                cleaned := value
            }

            function convert_t_rational_2_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_2_by_1(value)))
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

            function cleanup_t_rational_5_by_1(value) -> cleaned {
                cleaned := value
            }

            function convert_t_rational_5_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_5_by_1(value)))
            }

            function cleanup_t_rational_3_by_1(value) -> cleaned {
                cleaned := value
            }

            function convert_t_rational_3_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_3_by_1(value)))
            }

            function cleanup_t_rational_1000000007_by_1(value) -> cleaned {
                cleaned := value
            }

            function convert_t_rational_1000000007_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_1000000007_by_1(value)))
            }

            /// @src 0:83:127  "uint256 private constant MOD = 1_000_000_007"
            function constant_MOD_4() -> ret {
                /// @src 0:114:127  "1_000_000_007"
                let expr_3 := 0x3b9aca07
                let _10 := convert_t_rational_1000000007_by_1_to_t_uint256(expr_3)

                ret := _10
            }

            /// @ast-id 179
            /// @src 0:887:1246  "function polynomialReduce(uint256 x) public pure returns (uint256) {..."
            function fun_polynomialReduce_179(var_x_126) -> var__129 {
                /// @src 0:945:952  "uint256"
                let zero_t_uint256_1 := zero_value_for_split_t_uint256()
                var__129 := zero_t_uint256_1

                /// @src 0:1078:1079  "0"
                let expr_133 := 0x00
                /// @src 0:1061:1079  "uint256 result = 0"
                let var_result_132 := convert_t_rational_0_by_1_to_t_uint256(expr_133)
                /// @src 0:1089:1217  "for (uint256 i = 0; i < 64; i++) {..."
                for {
                    /// @src 0:1106:1107  "0"
                    let expr_137 := 0x00
                    /// @src 0:1094:1107  "uint256 i = 0"
                    let var_i_136 := convert_t_rational_0_by_1_to_t_uint256(expr_137)
                    } 1 {
                    /// @src 0:1117:1120  "i++"
                    let _3 := var_i_136
                    let _2 := increment_wrapping_t_uint256(_3)
                    var_i_136 := _2
                    let expr_143 := _3
                }
                {
                    /// @src 0:1109:1110  "i"
                    let _4 := var_i_136
                    let expr_139 := _4
                    /// @src 0:1113:1115  "64"
                    let expr_140 := 0x40
                    /// @src 0:1109:1115  "i < 64"
                    let expr_141 := lt(cleanup_t_uint256(expr_139), convert_t_rational_64_by_1_to_t_uint256(expr_140))
                    if iszero(expr_141) { break }
                    /// @src 0:1146:1152  "result"
                    let _5 := var_result_132
                    let expr_146 := _5
                    /// @src 0:1155:1156  "x"
                    let _6 := var_x_126
                    let expr_147 := _6
                    /// @src 0:1146:1156  "result * x"
                    let expr_148 := checked_mul_t_uint256(expr_146, expr_147)

                    /// @src 0:1160:1161  "i"
                    let _7 := var_i_136
                    let expr_149 := _7
                    /// @src 0:1164:1165  "2"
                    let expr_150 := 0x02
                    /// @src 0:1160:1165  "i % 2"
                    let expr_151 := mod_t_uint256(expr_149, convert_t_rational_2_by_1_to_t_uint256(expr_150))

                    /// @src 0:1169:1170  "0"
                    let expr_152 := 0x00
                    /// @src 0:1160:1170  "i % 2 == 0"
                    let expr_153 := eq(cleanup_t_uint256(expr_151), convert_t_rational_0_by_1_to_t_uint256(expr_152))
                    /// @src 0:1160:1198  "i % 2 == 0 ? 3 * (i + 1) : 5 * (i + 1)"
                    let expr_166
                    switch expr_153
                    case 0 {
                        /// @src 0:1187:1188  "5"
                        let expr_160 := 0x05
                        /// @src 0:1192:1193  "i"
                        let _8 := var_i_136
                        let expr_161 := _8
                        /// @src 0:1196:1197  "1"
                        let expr_162 := 0x01
                        /// @src 0:1192:1197  "i + 1"
                        let expr_163 := checked_add_t_uint256(expr_161, convert_t_rational_1_by_1_to_t_uint256(expr_162))

                        /// @src 0:1191:1198  "(i + 1)"
                        let expr_164 := expr_163
                        /// @src 0:1187:1198  "5 * (i + 1)"
                        let expr_165 := checked_mul_t_uint256(convert_t_rational_5_by_1_to_t_uint256(expr_160), expr_164)

                        /// @src 0:1160:1198  "i % 2 == 0 ? 3 * (i + 1) : 5 * (i + 1)"
                        expr_166 := expr_165
                    }
                    default {
                        /// @src 0:1173:1174  "3"
                        let expr_154 := 0x03
                        /// @src 0:1178:1179  "i"
                        let _9 := var_i_136
                        let expr_155 := _9
                        /// @src 0:1182:1183  "1"
                        let expr_156 := 0x01
                        /// @src 0:1178:1183  "i + 1"
                        let expr_157 := checked_add_t_uint256(expr_155, convert_t_rational_1_by_1_to_t_uint256(expr_156))

                        /// @src 0:1177:1184  "(i + 1)"
                        let expr_158 := expr_157
                        /// @src 0:1173:1184  "3 * (i + 1)"
                        let expr_159 := checked_mul_t_uint256(convert_t_rational_3_by_1_to_t_uint256(expr_154), expr_158)

                        /// @src 0:1160:1198  "i % 2 == 0 ? 3 * (i + 1) : 5 * (i + 1)"
                        expr_166 := expr_159
                    }
                    /// @src 0:1159:1199  "(i % 2 == 0 ? 3 * (i + 1) : 5 * (i + 1))"
                    let expr_167 := expr_166
                    /// @src 0:1146:1199  "result * x + (i % 2 == 0 ? 3 * (i + 1) : 5 * (i + 1))"
                    let expr_168 := checked_add_t_uint256(expr_148, expr_167)

                    /// @src 0:1145:1200  "(result * x + (i % 2 == 0 ? 3 * (i + 1) : 5 * (i + 1)))"
                    let expr_169 := expr_168
                    /// @src 0:1203:1206  "MOD"
                    let expr_170 := constant_MOD_4()
                    /// @src 0:1145:1206  "(result * x + (i % 2 == 0 ? 3 * (i + 1) : 5 * (i + 1))) % MOD"
                    let expr_171 := mod_t_uint256(expr_169, expr_170)

                    /// @src 0:1136:1206  "result = (result * x + (i % 2 == 0 ? 3 * (i + 1) : 5 * (i + 1))) % MOD"
                    var_result_132 := expr_171
                    let expr_172 := expr_171
                }
                /// @src 0:1233:1239  "result"
                let _11 := var_result_132
                let expr_176 := _11
                /// @src 0:1226:1239  "return result"
                var__129 := expr_176
                leave

            }
            /// @src 0:58:2373  "contract HeavyMath {..."

            function increment_t_uint256(value) -> ret {
                value := cleanup_t_uint256(value)
                if eq(value, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) { panic_error_0x11() }
                ret := add(value, 1)
            }

            /// @ast-id 30
            /// @src 0:134:287  "function sumOfSquares(uint256 n) public pure returns (uint256 acc) {..."
            function fun_sumOfSquares_30(var_n_6) -> var_acc_9 {
                /// @src 0:188:199  "uint256 acc"
                let zero_t_uint256_12 := zero_value_for_split_t_uint256()
                var_acc_9 := zero_t_uint256_12

                /// @src 0:211:281  "for (uint256 i = 1; i <= n; i++) {..."
                for {
                    /// @src 0:228:229  "1"
                    let expr_13 := 0x01
                    /// @src 0:216:229  "uint256 i = 1"
                    let var_i_12 := convert_t_rational_1_by_1_to_t_uint256(expr_13)
                    } 1 {
                    /// @src 0:239:242  "i++"
                    let _14 := var_i_12
                    let _13 := increment_t_uint256(_14)
                    var_i_12 := _13
                    let expr_19 := _14
                }
                {
                    /// @src 0:231:232  "i"
                    let _15 := var_i_12
                    let expr_15 := _15
                    /// @src 0:236:237  "n"
                    let _16 := var_n_6
                    let expr_16 := _16
                    /// @src 0:231:237  "i <= n"
                    let expr_17 := iszero(gt(cleanup_t_uint256(expr_15), cleanup_t_uint256(expr_16)))
                    if iszero(expr_17) { break }
                    /// @src 0:265:266  "i"
                    let _17 := var_i_12
                    let expr_22 := _17
                    /// @src 0:269:270  "i"
                    let _18 := var_i_12
                    let expr_23 := _18
                    /// @src 0:265:270  "i * i"
                    let expr_24 := checked_mul_t_uint256(expr_22, expr_23)

                    /// @src 0:258:270  "acc += i * i"
                    let _19 := var_acc_9
                    let expr_25 := checked_add_t_uint256(_19, expr_24)

                    var_acc_9 := expr_25
                }

            }
            /// @src 0:58:2373  "contract HeavyMath {..."

            /// @ast-id 124
            /// @src 0:532:881  "function fibonacci(uint256 n) public pure returns (uint256) {..."
            function fun_fibonacci_124(var_n_72) -> var__75 {
                /// @src 0:583:590  "uint256"
                let zero_t_uint256_20 := zero_value_for_split_t_uint256()
                var__75 := zero_t_uint256_20

                /// @src 0:606:607  "n"
                let _21 := var_n_72
                let expr_77 := _21
                /// @src 0:611:612  "0"
                let expr_78 := 0x00
                /// @src 0:606:612  "n == 0"
                let expr_79 := eq(cleanup_t_uint256(expr_77), convert_t_rational_0_by_1_to_t_uint256(expr_78))
                /// @src 0:602:647  "if (n == 0) {..."
                if expr_79 {
                    /// @src 0:635:636  "0"
                    let expr_80 := 0x00
                    /// @src 0:628:636  "return 0"
                    var__75 := convert_t_rational_0_by_1_to_t_uint256(expr_80)
                    leave
                    /// @src 0:602:647  "if (n == 0) {..."
                }
                /// @src 0:660:661  "n"
                let _22 := var_n_72
                let expr_84 := _22
                /// @src 0:665:666  "1"
                let expr_85 := 0x01
                /// @src 0:660:666  "n == 1"
                let expr_86 := eq(cleanup_t_uint256(expr_84), convert_t_rational_1_by_1_to_t_uint256(expr_85))
                /// @src 0:656:701  "if (n == 1) {..."
                if expr_86 {
                    /// @src 0:689:690  "1"
                    let expr_87 := 0x01
                    /// @src 0:682:690  "return 1"
                    var__75 := convert_t_rational_1_by_1_to_t_uint256(expr_87)
                    leave
                    /// @src 0:656:701  "if (n == 1) {..."
                }
                /// @src 0:725:726  "0"
                let expr_93 := 0x00
                /// @src 0:710:726  "uint256 prev = 0"
                let var_prev_92 := convert_t_rational_0_by_1_to_t_uint256(expr_93)
                /// @src 0:751:752  "1"
                let expr_97 := 0x01
                /// @src 0:736:752  "uint256 curr = 1"
                let var_curr_96 := convert_t_rational_1_by_1_to_t_uint256(expr_97)
                /// @src 0:762:854  "for (uint256 i = 2; i <= n; i++) {..."
                for {
                    /// @src 0:779:780  "2"
                    let expr_101 := 0x02
                    /// @src 0:767:780  "uint256 i = 2"
                    let var_i_100 := convert_t_rational_2_by_1_to_t_uint256(expr_101)
                    } 1 {
                    /// @src 0:790:793  "i++"
                    let _24 := var_i_100
                    let _23 := increment_t_uint256(_24)
                    var_i_100 := _23
                    let expr_107 := _24
                }
                {
                    /// @src 0:782:783  "i"
                    let _25 := var_i_100
                    let expr_103 := _25
                    /// @src 0:787:788  "n"
                    let _26 := var_n_72
                    let expr_104 := _26
                    /// @src 0:782:788  "i <= n"
                    let expr_105 := iszero(gt(cleanup_t_uint256(expr_103), cleanup_t_uint256(expr_104)))
                    if iszero(expr_105) { break }
                    /// @src 0:825:829  "curr"
                    let _27 := var_curr_96
                    let expr_112 := _27
                    /// @src 0:824:843  "(curr, prev + curr)"
                    let expr_116_component_1 := expr_112
                    /// @src 0:831:835  "prev"
                    let _28 := var_prev_92
                    let expr_113 := _28
                    /// @src 0:838:842  "curr"
                    let _29 := var_curr_96
                    let expr_114 := _29
                    /// @src 0:831:842  "prev + curr"
                    let expr_115 := checked_add_t_uint256(expr_113, expr_114)

                    /// @src 0:824:843  "(curr, prev + curr)"
                    let expr_116_component_2 := expr_115
                    /// @src 0:809:843  "(prev, curr) = (curr, prev + curr)"
                    var_curr_96 := expr_116_component_2
                    var_prev_92 := expr_116_component_1
                }
                /// @src 0:870:874  "curr"
                let _30 := var_curr_96
                let expr_121 := _30
                /// @src 0:863:874  "return curr"
                var__75 := expr_121
                leave

            }
            /// @src 0:58:2373  "contract HeavyMath {..."

            function cleanup_t_rational_11_by_1(value) -> cleaned {
                cleaned := value
            }

            function convert_t_rational_11_by_1_to_t_uint256(value) -> converted {
                converted := cleanup_t_uint256(identity(cleanup_t_rational_11_by_1(value)))
            }

            /// @ast-id 251
            /// @src 0:1252:1639  "function mixedSeries(uint256 seed, uint256 rounds) public pure returns (uint256) {..."
            function fun_mixedSeries_251(var_seed_181, var_rounds_183) -> var__186 {
                /// @src 0:1324:1331  "uint256"
                let zero_t_uint256_31 := zero_value_for_split_t_uint256()
                var__186 := zero_t_uint256_31

                /// @src 0:1357:1361  "seed"
                let _32 := var_seed_181
                let expr_190 := _32
                /// @src 0:1364:1367  "MOD"
                let expr_191 := constant_MOD_4()
                /// @src 0:1357:1367  "seed % MOD"
                let expr_192 := mod_t_uint256(expr_190, expr_191)

                /// @src 0:1343:1367  "uint256 acc = seed % MOD"
                let var_acc_189 := expr_192
                /// @src 0:1377:1613  "for (uint256 i = 1; i <= rounds; i++) {..."
                for {
                    /// @src 0:1394:1395  "1"
                    let expr_196 := 0x01
                    /// @src 0:1382:1395  "uint256 i = 1"
                    let var_i_195 := convert_t_rational_1_by_1_to_t_uint256(expr_196)
                    } 1 {
                    /// @src 0:1410:1413  "i++"
                    let _34 := var_i_195
                    let _33 := increment_t_uint256(_34)
                    var_i_195 := _33
                    let expr_202 := _34
                }
                {
                    /// @src 0:1397:1398  "i"
                    let _35 := var_i_195
                    let expr_198 := _35
                    /// @src 0:1402:1408  "rounds"
                    let _36 := var_rounds_183
                    let expr_199 := _36
                    /// @src 0:1397:1408  "i <= rounds"
                    let expr_200 := iszero(gt(cleanup_t_uint256(expr_198), cleanup_t_uint256(expr_199)))
                    if iszero(expr_200) { break }
                    /// @src 0:1436:1439  "acc"
                    let _37 := var_acc_189
                    let expr_205 := _37
                    /// @src 0:1463:1464  "i"
                    let _38 := var_i_195
                    let expr_207 := _38
                    /// @src 0:1467:1471  "seed"
                    let _39 := var_seed_181
                    let expr_208 := _39
                    /// @src 0:1463:1471  "i + seed"
                    let expr_209 := checked_add_t_uint256(expr_207, expr_208)

                    /// @src 0:1442:1472  "sumOfSquaresInternal(i + seed)"
                    let expr_210 := fun_sumOfSquaresInternal_277(expr_209)
                    /// @src 0:1436:1472  "acc + sumOfSquaresInternal(i + seed)"
                    let expr_211 := checked_add_t_uint256(expr_205, expr_210)

                    /// @src 0:1435:1473  "(acc + sumOfSquaresInternal(i + seed))"
                    let expr_212 := expr_211
                    /// @src 0:1476:1479  "MOD"
                    let expr_213 := constant_MOD_4()
                    /// @src 0:1435:1479  "(acc + sumOfSquaresInternal(i + seed)) % MOD"
                    let expr_214 := mod_t_uint256(expr_212, expr_213)

                    /// @src 0:1429:1479  "acc = (acc + sumOfSquaresInternal(i + seed)) % MOD"
                    var_acc_189 := expr_214
                    let expr_215 := expr_214
                    /// @src 0:1500:1503  "acc"
                    let _40 := var_acc_189
                    let expr_218 := _40
                    /// @src 0:1524:1525  "i"
                    let _41 := var_i_195
                    let expr_220 := _41
                    /// @src 0:1528:1529  "5"
                    let expr_221 := 0x05
                    /// @src 0:1524:1529  "i + 5"
                    let expr_222 := checked_add_t_uint256(expr_220, convert_t_rational_5_by_1_to_t_uint256(expr_221))

                    /// @src 0:1506:1530  "fibonacciInternal(i + 5)"
                    let expr_223 := fun_fibonacciInternal_333(expr_222)
                    /// @src 0:1500:1530  "acc * fibonacciInternal(i + 5)"
                    let expr_224 := checked_mul_t_uint256(expr_218, expr_223)

                    /// @src 0:1499:1531  "(acc * fibonacciInternal(i + 5))"
                    let expr_225 := expr_224
                    /// @src 0:1534:1537  "MOD"
                    let expr_226 := constant_MOD_4()
                    /// @src 0:1499:1537  "(acc * fibonacciInternal(i + 5)) % MOD"
                    let expr_227 := mod_t_uint256(expr_225, expr_226)

                    /// @src 0:1493:1537  "acc = (acc * fibonacciInternal(i + 5)) % MOD"
                    var_acc_189 := expr_227
                    let expr_228 := expr_227
                    /// @src 0:1558:1561  "acc"
                    let _42 := var_acc_189
                    let expr_231 := _42
                    /// @src 0:1583:1584  "i"
                    let _43 := var_i_195
                    let expr_233 := _43
                    /// @src 0:1587:1589  "11"
                    let expr_234 := 0x0b
                    /// @src 0:1583:1589  "i % 11"
                    let expr_235 := mod_t_uint256(expr_233, convert_t_rational_11_by_1_to_t_uint256(expr_234))

                    /// @src 0:1582:1590  "(i % 11)"
                    let expr_236 := expr_235
                    /// @src 0:1593:1594  "5"
                    let expr_237 := 0x05
                    /// @src 0:1582:1594  "(i % 11) + 5"
                    let expr_238 := checked_add_t_uint256(expr_236, convert_t_rational_5_by_1_to_t_uint256(expr_237))

                    /// @src 0:1564:1595  "factorialInternal((i % 11) + 5)"
                    let expr_239 := fun_factorialInternal_366(expr_238)
                    /// @src 0:1558:1595  "acc + factorialInternal((i % 11) + 5)"
                    let expr_240 := checked_add_t_uint256(expr_231, expr_239)

                    /// @src 0:1557:1596  "(acc + factorialInternal((i % 11) + 5))"
                    let expr_241 := expr_240
                    /// @src 0:1599:1602  "MOD"
                    let expr_242 := constant_MOD_4()
                    /// @src 0:1557:1602  "(acc + factorialInternal((i % 11) + 5)) % MOD"
                    let expr_243 := mod_t_uint256(expr_241, expr_242)

                    /// @src 0:1551:1602  "acc = (acc + factorialInternal((i % 11) + 5)) % MOD"
                    var_acc_189 := expr_243
                    let expr_244 := expr_243
                }
                /// @src 0:1629:1632  "acc"
                let _44 := var_acc_189
                let expr_248 := _44
                /// @src 0:1622:1632  "return acc"
                var__186 := expr_248
                leave

            }
            /// @src 0:58:2373  "contract HeavyMath {..."

            /// @ast-id 70
            /// @src 0:293:526  "function factorialMod(uint256 n) public pure returns (uint256 acc) {..."
            function fun_factorialMod_70(var_n_32) -> var_acc_35 {
                /// @src 0:347:358  "uint256 acc"
                let zero_t_uint256_45 := zero_value_for_split_t_uint256()
                var_acc_35 := zero_t_uint256_45

                /// @src 0:374:375  "n"
                let _46 := var_n_32
                let expr_37 := _46
                /// @src 0:379:380  "0"
                let expr_38 := 0x00
                /// @src 0:374:380  "n == 0"
                let expr_39 := eq(cleanup_t_uint256(expr_37), convert_t_rational_0_by_1_to_t_uint256(expr_38))
                /// @src 0:370:415  "if (n == 0) {..."
                if expr_39 {
                    /// @src 0:403:404  "1"
                    let expr_40 := 0x01
                    /// @src 0:396:404  "return 1"
                    var_acc_35 := convert_t_rational_1_by_1_to_t_uint256(expr_40)
                    leave
                    /// @src 0:370:415  "if (n == 0) {..."
                }
                /// @src 0:430:431  "1"
                let expr_45 := 0x01
                /// @src 0:424:431  "acc = 1"
                let _47 := convert_t_rational_1_by_1_to_t_uint256(expr_45)
                var_acc_35 := _47
                let expr_46 := _47
                /// @src 0:441:520  "for (uint256 i = 2; i <= n; i++) {..."
                for {
                    /// @src 0:458:459  "2"
                    let expr_50 := 0x02
                    /// @src 0:446:459  "uint256 i = 2"
                    let var_i_49 := convert_t_rational_2_by_1_to_t_uint256(expr_50)
                    } 1 {
                    /// @src 0:469:472  "i++"
                    let _49 := var_i_49
                    let _48 := increment_t_uint256(_49)
                    var_i_49 := _48
                    let expr_56 := _49
                }
                {
                    /// @src 0:461:462  "i"
                    let _50 := var_i_49
                    let expr_52 := _50
                    /// @src 0:466:467  "n"
                    let _51 := var_n_32
                    let expr_53 := _51
                    /// @src 0:461:467  "i <= n"
                    let expr_54 := iszero(gt(cleanup_t_uint256(expr_52), cleanup_t_uint256(expr_53)))
                    if iszero(expr_54) { break }
                    /// @src 0:495:498  "acc"
                    let _52 := var_acc_35
                    let expr_59 := _52
                    /// @src 0:501:502  "i"
                    let _53 := var_i_49
                    let expr_60 := _53
                    /// @src 0:495:502  "acc * i"
                    let expr_61 := checked_mul_t_uint256(expr_59, expr_60)

                    /// @src 0:494:503  "(acc * i)"
                    let expr_62 := expr_61
                    /// @src 0:506:509  "MOD"
                    let expr_63 := constant_MOD_4()
                    /// @src 0:494:509  "(acc * i) % MOD"
                    let expr_64 := mod_t_uint256(expr_62, expr_63)

                    /// @src 0:488:509  "acc = (acc * i) % MOD"
                    var_acc_35 := expr_64
                    let expr_65 := expr_64
                }

            }
            /// @src 0:58:2373  "contract HeavyMath {..."

            /// @ast-id 277
            /// @src 0:1645:1808  "function sumOfSquaresInternal(uint256 n) internal pure returns (uint256 acc) {..."
            function fun_sumOfSquaresInternal_277(var_n_253) -> var_acc_256 {
                /// @src 0:1709:1720  "uint256 acc"
                let zero_t_uint256_54 := zero_value_for_split_t_uint256()
                var_acc_256 := zero_t_uint256_54

                /// @src 0:1732:1802  "for (uint256 i = 1; i <= n; i++) {..."
                for {
                    /// @src 0:1749:1750  "1"
                    let expr_260 := 0x01
                    /// @src 0:1737:1750  "uint256 i = 1"
                    let var_i_259 := convert_t_rational_1_by_1_to_t_uint256(expr_260)
                    } 1 {
                    /// @src 0:1760:1763  "i++"
                    let _56 := var_i_259
                    let _55 := increment_t_uint256(_56)
                    var_i_259 := _55
                    let expr_266 := _56
                }
                {
                    /// @src 0:1752:1753  "i"
                    let _57 := var_i_259
                    let expr_262 := _57
                    /// @src 0:1757:1758  "n"
                    let _58 := var_n_253
                    let expr_263 := _58
                    /// @src 0:1752:1758  "i <= n"
                    let expr_264 := iszero(gt(cleanup_t_uint256(expr_262), cleanup_t_uint256(expr_263)))
                    if iszero(expr_264) { break }
                    /// @src 0:1786:1787  "i"
                    let _59 := var_i_259
                    let expr_269 := _59
                    /// @src 0:1790:1791  "i"
                    let _60 := var_i_259
                    let expr_270 := _60
                    /// @src 0:1786:1791  "i * i"
                    let expr_271 := checked_mul_t_uint256(expr_269, expr_270)

                    /// @src 0:1779:1791  "acc += i * i"
                    let _61 := var_acc_256
                    let expr_272 := checked_add_t_uint256(_61, expr_271)

                    var_acc_256 := expr_272
                }

            }
            /// @src 0:58:2373  "contract HeavyMath {..."

            /// @ast-id 333
            /// @src 0:1814:2179  "function fibonacciInternal(uint256 n) internal pure returns (uint256) {..."
            function fun_fibonacciInternal_333(var_n_279) -> var__282 {
                /// @src 0:1875:1882  "uint256"
                let zero_t_uint256_62 := zero_value_for_split_t_uint256()
                var__282 := zero_t_uint256_62

                /// @src 0:1898:1899  "n"
                let _63 := var_n_279
                let expr_284 := _63
                /// @src 0:1903:1904  "0"
                let expr_285 := 0x00
                /// @src 0:1898:1904  "n == 0"
                let expr_286 := eq(cleanup_t_uint256(expr_284), convert_t_rational_0_by_1_to_t_uint256(expr_285))
                /// @src 0:1894:1939  "if (n == 0) {..."
                if expr_286 {
                    /// @src 0:1927:1928  "0"
                    let expr_287 := 0x00
                    /// @src 0:1920:1928  "return 0"
                    var__282 := convert_t_rational_0_by_1_to_t_uint256(expr_287)
                    leave
                    /// @src 0:1894:1939  "if (n == 0) {..."
                }
                /// @src 0:1952:1953  "n"
                let _64 := var_n_279
                let expr_291 := _64
                /// @src 0:1957:1958  "1"
                let expr_292 := 0x01
                /// @src 0:1952:1958  "n == 1"
                let expr_293 := eq(cleanup_t_uint256(expr_291), convert_t_rational_1_by_1_to_t_uint256(expr_292))
                /// @src 0:1948:1993  "if (n == 1) {..."
                if expr_293 {
                    /// @src 0:1981:1982  "1"
                    let expr_294 := 0x01
                    /// @src 0:1974:1982  "return 1"
                    var__282 := convert_t_rational_1_by_1_to_t_uint256(expr_294)
                    leave
                    /// @src 0:1948:1993  "if (n == 1) {..."
                }
                /// @src 0:2017:2018  "0"
                let expr_300 := 0x00
                /// @src 0:2002:2018  "uint256 prev = 0"
                let var_prev_299 := convert_t_rational_0_by_1_to_t_uint256(expr_300)
                /// @src 0:2043:2044  "1"
                let expr_304 := 0x01
                /// @src 0:2028:2044  "uint256 curr = 1"
                let var_curr_303 := convert_t_rational_1_by_1_to_t_uint256(expr_304)
                /// @src 0:2054:2146  "for (uint256 i = 2; i <= n; i++) {..."
                for {
                    /// @src 0:2071:2072  "2"
                    let expr_308 := 0x02
                    /// @src 0:2059:2072  "uint256 i = 2"
                    let var_i_307 := convert_t_rational_2_by_1_to_t_uint256(expr_308)
                    } 1 {
                    /// @src 0:2082:2085  "i++"
                    let _66 := var_i_307
                    let _65 := increment_t_uint256(_66)
                    var_i_307 := _65
                    let expr_314 := _66
                }
                {
                    /// @src 0:2074:2075  "i"
                    let _67 := var_i_307
                    let expr_310 := _67
                    /// @src 0:2079:2080  "n"
                    let _68 := var_n_279
                    let expr_311 := _68
                    /// @src 0:2074:2080  "i <= n"
                    let expr_312 := iszero(gt(cleanup_t_uint256(expr_310), cleanup_t_uint256(expr_311)))
                    if iszero(expr_312) { break }
                    /// @src 0:2117:2121  "curr"
                    let _69 := var_curr_303
                    let expr_319 := _69
                    /// @src 0:2116:2135  "(curr, prev + curr)"
                    let expr_323_component_1 := expr_319
                    /// @src 0:2123:2127  "prev"
                    let _70 := var_prev_299
                    let expr_320 := _70
                    /// @src 0:2130:2134  "curr"
                    let _71 := var_curr_303
                    let expr_321 := _71
                    /// @src 0:2123:2134  "prev + curr"
                    let expr_322 := checked_add_t_uint256(expr_320, expr_321)

                    /// @src 0:2116:2135  "(curr, prev + curr)"
                    let expr_323_component_2 := expr_322
                    /// @src 0:2101:2135  "(prev, curr) = (curr, prev + curr)"
                    var_curr_303 := expr_323_component_2
                    var_prev_299 := expr_323_component_1
                }
                /// @src 0:2162:2166  "curr"
                let _72 := var_curr_303
                let expr_328 := _72
                /// @src 0:2169:2172  "MOD"
                let expr_329 := constant_MOD_4()
                /// @src 0:2162:2172  "curr % MOD"
                let expr_330 := mod_t_uint256(expr_328, expr_329)

                /// @src 0:2155:2172  "return curr % MOD"
                var__282 := expr_330
                leave

            }
            /// @src 0:58:2373  "contract HeavyMath {..."

            /// @ast-id 366
            /// @src 0:2185:2371  "function factorialInternal(uint256 n) internal pure returns (uint256 acc) {..."
            function fun_factorialInternal_366(var_n_335) -> var_acc_338 {
                /// @src 0:2246:2257  "uint256 acc"
                let zero_t_uint256_73 := zero_value_for_split_t_uint256()
                var_acc_338 := zero_t_uint256_73

                /// @src 0:2275:2276  "1"
                let expr_341 := 0x01
                /// @src 0:2269:2276  "acc = 1"
                let _74 := convert_t_rational_1_by_1_to_t_uint256(expr_341)
                var_acc_338 := _74
                let expr_342 := _74
                /// @src 0:2286:2365  "for (uint256 i = 2; i <= n; i++) {..."
                for {
                    /// @src 0:2303:2304  "2"
                    let expr_346 := 0x02
                    /// @src 0:2291:2304  "uint256 i = 2"
                    let var_i_345 := convert_t_rational_2_by_1_to_t_uint256(expr_346)
                    } 1 {
                    /// @src 0:2314:2317  "i++"
                    let _76 := var_i_345
                    let _75 := increment_t_uint256(_76)
                    var_i_345 := _75
                    let expr_352 := _76
                }
                {
                    /// @src 0:2306:2307  "i"
                    let _77 := var_i_345
                    let expr_348 := _77
                    /// @src 0:2311:2312  "n"
                    let _78 := var_n_335
                    let expr_349 := _78
                    /// @src 0:2306:2312  "i <= n"
                    let expr_350 := iszero(gt(cleanup_t_uint256(expr_348), cleanup_t_uint256(expr_349)))
                    if iszero(expr_350) { break }
                    /// @src 0:2340:2343  "acc"
                    let _79 := var_acc_338
                    let expr_355 := _79
                    /// @src 0:2346:2347  "i"
                    let _80 := var_i_345
                    let expr_356 := _80
                    /// @src 0:2340:2347  "acc * i"
                    let expr_357 := checked_mul_t_uint256(expr_355, expr_356)

                    /// @src 0:2339:2348  "(acc * i)"
                    let expr_358 := expr_357
                    /// @src 0:2351:2354  "MOD"
                    let expr_359 := constant_MOD_4()
                    /// @src 0:2339:2354  "(acc * i) % MOD"
                    let expr_360 := mod_t_uint256(expr_358, expr_359)

                    /// @src 0:2333:2354  "acc = (acc * i) % MOD"
                    var_acc_338 := expr_360
                    let expr_361 := expr_360
                }

            }
            /// @src 0:58:2373  "contract HeavyMath {..."

        }

        data ".metadata" hex"a2646970667358221220fbb9d90e1f16e8e524e1dc19db5e24becc2fb2a32a5e90879a2006beb7cd70a664736f6c634300081e0033"
    }

}

