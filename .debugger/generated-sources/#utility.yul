{

    function allocate_unbounded() -> memPtr {
        memPtr := mload(64)
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

    function copy_calldata_to_memory(src, dst, length) {
        calldatacopy(dst, src, length)
        // clear end
        mstore(add(dst, length), 0)
    }

    function abi_decode_available_length_t_string_memory_ptr(src, length, end) -> array {
        array := allocate_memory(array_allocation_size_t_string_memory_ptr(length))
        mstore(array, length)
        let dst := add(array, 0x20)
        if gt(add(src, length), end) { revert_error_987264b3b1d58a9c7f8255e93e81c77d86d6299019c33110a076957a3e06e2ae() }
        copy_calldata_to_memory(src, dst, length)
    }

    // string
    function abi_decode_t_string_memory_ptr(offset, end) -> array {
        if iszero(slt(add(offset, 0x1f), end)) { revert_error_1b9f4a0a5773e33b91aa01db23bf8c55fce1411167c872835e7fa00a4f17d46d() }
        let length := calldataload(offset)
        array := abi_decode_available_length_t_string_memory_ptr(add(offset, 0x20), length, end)
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

    function abi_decode_tuple_t_addresst_string_memory_ptrt_uint256t_uint256(headStart, dataEnd) -> value0, value1, value2, value3 {
        if slt(sub(dataEnd, headStart), 128) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

        {

            let offset := 0

            value0 := abi_decode_t_address(add(headStart, offset), dataEnd)
        }

        {

            let offset := calldataload(add(headStart, 32))
            if gt(offset, 0xffffffffffffffff) { revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() }

            value1 := abi_decode_t_string_memory_ptr(add(headStart, offset), dataEnd)
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

    function cleanup_t_bytes32(value) -> cleaned {
        cleaned := value
    }

    function abi_encode_t_bytes32_to_t_bytes32_fromStack(value, pos) {
        mstore(pos, cleanup_t_bytes32(value))
    }

    function abi_encode_tuple_t_bytes32__to_t_bytes32__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 32)

        abi_encode_t_bytes32_to_t_bytes32_fromStack(value0,  add(headStart, 0))

    }

    function cleanup_t_uint16(value) -> cleaned {
        cleaned := and(value, 0xffff)
    }

    function validator_revert_t_uint16(value) {
        if iszero(eq(value, cleanup_t_uint16(value))) { revert(0, 0) }
    }

    function abi_decode_t_uint16(offset, end) -> value {
        value := calldataload(offset)
        validator_revert_t_uint16(value)
    }

    function abi_decode_tuple_t_string_memory_ptrt_uint16(headStart, dataEnd) -> value0, value1 {
        if slt(sub(dataEnd, headStart), 64) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

        {

            let offset := calldataload(add(headStart, 0))
            if gt(offset, 0xffffffffffffffff) { revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() }

            value0 := abi_decode_t_string_memory_ptr(add(headStart, offset), dataEnd)
        }

        {

            let offset := 32

            value1 := abi_decode_t_uint16(add(headStart, offset), dataEnd)
        }

    }

    function array_length_t_string_memory_ptr(value) -> length {

        length := mload(value)

    }

    function array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, length) -> updated_pos {
        mstore(pos, length)
        updated_pos := add(pos, 0x20)
    }

    function copy_memory_to_memory(src, dst, length) {
        let i := 0
        for { } lt(i, length) { i := add(i, 32) }
        {
            mstore(add(dst, i), mload(add(src, i)))
        }
        if gt(i, length)
        {
            // clear end
            mstore(add(dst, length), 0)
        }
    }

    function abi_encode_t_string_memory_ptr_to_t_string_memory_ptr_fromStack(value, pos) -> end {
        let length := array_length_t_string_memory_ptr(value)
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, length)
        copy_memory_to_memory(add(value, 0x20), pos, length)
        end := add(pos, round_up_to_mul_of_32(length))
    }

    function abi_encode_t_uint256_to_t_uint256_fromStack(value, pos) {
        mstore(pos, cleanup_t_uint256(value))
    }

    function abi_encode_tuple_t_string_memory_ptr_t_uint256__to_t_string_memory_ptr_t_uint256__fromStack_reversed(headStart , value1, value0) -> tail {
        tail := add(headStart, 64)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_string_memory_ptr_to_t_string_memory_ptr_fromStack(value0,  tail)

        abi_encode_t_uint256_to_t_uint256_fromStack(value1,  add(headStart, 32))

    }

    function abi_decode_tuple_t_addresst_string_memory_ptr(headStart, dataEnd) -> value0, value1 {
        if slt(sub(dataEnd, headStart), 64) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

        {

            let offset := 0

            value0 := abi_decode_t_address(add(headStart, offset), dataEnd)
        }

        {

            let offset := calldataload(add(headStart, 32))
            if gt(offset, 0xffffffffffffffff) { revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() }

            value1 := abi_decode_t_string_memory_ptr(add(headStart, offset), dataEnd)
        }

    }

    function abi_decode_tuple_t_string_memory_ptr(headStart, dataEnd) -> value0 {
        if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

        {

            let offset := calldataload(add(headStart, 0))
            if gt(offset, 0xffffffffffffffff) { revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() }

            value0 := abi_decode_t_string_memory_ptr(add(headStart, offset), dataEnd)
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

    function abi_encode_t_address_to_t_address_fromStack(value, pos) {
        mstore(pos, cleanup_t_address(value))
    }

    function abi_encode_tuple_t_array$_t_uint256_$dyn_memory_ptr_t_address_t_uint256__to_t_array$_t_uint256_$dyn_memory_ptr_t_address_t_uint256__fromStack_reversed(headStart , value2, value1, value0) -> tail {
        tail := add(headStart, 96)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_array$_t_uint256_$dyn_memory_ptr_to_t_array$_t_uint256_$dyn_memory_ptr_fromStack(value0,  tail)

        abi_encode_t_address_to_t_address_fromStack(value1,  add(headStart, 32))

        abi_encode_t_uint256_to_t_uint256_fromStack(value2,  add(headStart, 64))

    }

    function cleanup_t_uint32(value) -> cleaned {
        cleaned := and(value, 0xffffffff)
    }

    function abi_encode_t_uint32_to_t_uint32_fromStack(value, pos) {
        mstore(pos, cleanup_t_uint32(value))
    }

    function cleanup_t_uint64(value) -> cleaned {
        cleaned := and(value, 0xffffffffffffffff)
    }

    function abi_encode_t_uint64_to_t_uint64_fromStack(value, pos) {
        mstore(pos, cleanup_t_uint64(value))
    }

    function abi_encode_t_uint16_to_t_uint16_fromStack(value, pos) {
        mstore(pos, cleanup_t_uint16(value))
    }

    function cleanup_t_bool(value) -> cleaned {
        cleaned := iszero(iszero(value))
    }

    function abi_encode_t_bool_to_t_bool_fromStack(value, pos) {
        mstore(pos, cleanup_t_bool(value))
    }

    function abi_encode_tuple_t_address_t_uint32_t_uint64_t_uint64_t_uint16_t_bool__to_t_address_t_uint32_t_uint64_t_uint64_t_uint16_t_bool__fromStack_reversed(headStart , value5, value4, value3, value2, value1, value0) -> tail {
        tail := add(headStart, 192)

        abi_encode_t_address_to_t_address_fromStack(value0,  add(headStart, 0))

        abi_encode_t_uint32_to_t_uint32_fromStack(value1,  add(headStart, 32))

        abi_encode_t_uint64_to_t_uint64_fromStack(value2,  add(headStart, 64))

        abi_encode_t_uint64_to_t_uint64_fromStack(value3,  add(headStart, 96))

        abi_encode_t_uint16_to_t_uint16_fromStack(value4,  add(headStart, 128))

        abi_encode_t_bool_to_t_bool_fromStack(value5,  add(headStart, 160))

    }

    function abi_decode_tuple_t_address(headStart, dataEnd) -> value0 {
        if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

        {

            let offset := 0

            value0 := abi_decode_t_address(add(headStart, offset), dataEnd)
        }

    }

    function abi_encode_tuple_t_uint256__to_t_uint256__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 32)

        abi_encode_t_uint256_to_t_uint256_fromStack(value0,  add(headStart, 0))

    }

    function abi_decode_tuple_t_uint256(headStart, dataEnd) -> value0 {
        if slt(sub(dataEnd, headStart), 32) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

        {

            let offset := 0

            value0 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
        }

    }

    function array_length_t_array$_t_address_$dyn_memory_ptr(value) -> length {

        length := mload(value)

    }

    function array_storeLengthForEncoding_t_array$_t_address_$dyn_memory_ptr_fromStack(pos, length) -> updated_pos {
        mstore(pos, length)
        updated_pos := add(pos, 0x20)
    }

    function array_dataslot_t_array$_t_address_$dyn_memory_ptr(ptr) -> data {
        data := ptr

        data := add(ptr, 0x20)

    }

    function abi_encode_t_address_to_t_address(value, pos) {
        mstore(pos, cleanup_t_address(value))
    }

    function abi_encodeUpdatedPos_t_address_to_t_address(value0, pos) -> updatedPos {
        abi_encode_t_address_to_t_address(value0, pos)
        updatedPos := add(pos, 0x20)
    }

    function array_nextElement_t_array$_t_address_$dyn_memory_ptr(ptr) -> next {
        next := add(ptr, 0x20)
    }

    // address[] -> address[]
    function abi_encode_t_array$_t_address_$dyn_memory_ptr_to_t_array$_t_address_$dyn_memory_ptr_fromStack(value, pos)  -> end  {
        let length := array_length_t_array$_t_address_$dyn_memory_ptr(value)
        pos := array_storeLengthForEncoding_t_array$_t_address_$dyn_memory_ptr_fromStack(pos, length)
        let baseRef := array_dataslot_t_array$_t_address_$dyn_memory_ptr(value)
        let srcPtr := baseRef
        for { let i := 0 } lt(i, length) { i := add(i, 1) }
        {
            let elementValue0 := mload(srcPtr)
            pos := abi_encodeUpdatedPos_t_address_to_t_address(elementValue0, pos)
            srcPtr := array_nextElement_t_array$_t_address_$dyn_memory_ptr(srcPtr)
        }
        end := pos
    }

    function abi_encode_tuple_t_array$_t_address_$dyn_memory_ptr__to_t_array$_t_address_$dyn_memory_ptr__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_array$_t_address_$dyn_memory_ptr_to_t_array$_t_address_$dyn_memory_ptr_fromStack(value0,  tail)

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

    function array_storeLengthForEncoding_t_string_memory_ptr_nonPadded_inplace_fromStack(pos, length) -> updated_pos {
        updated_pos := pos
    }

    function store_literal_in_memory_a5525611f24e1bc6071cb449f9685b260409906e0e34e953f90e158cb34b71f7(memPtr) {

        mstore(add(memPtr, 0), "metatransaction Voting ")

    }

    function abi_encode_t_stringliteral_a5525611f24e1bc6071cb449f9685b260409906e0e34e953f90e158cb34b71f7_to_t_string_memory_ptr_nonPadded_inplace_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_nonPadded_inplace_fromStack(pos, 23)
        store_literal_in_memory_a5525611f24e1bc6071cb449f9685b260409906e0e34e953f90e158cb34b71f7(pos)
        end := add(pos, 23)
    }

    function abi_encode_t_string_memory_ptr_to_t_string_memory_ptr_nonPadded_inplace_fromStack(value, pos) -> end {
        let length := array_length_t_string_memory_ptr(value)
        pos := array_storeLengthForEncoding_t_string_memory_ptr_nonPadded_inplace_fromStack(pos, length)
        copy_memory_to_memory(add(value, 0x20), pos, length)
        end := add(pos, length)
    }

    function leftAlign_t_uint256(value) -> aligned {
        aligned := value
    }

    function abi_encode_t_uint256_to_t_uint256_nonPadded_inplace_fromStack(value, pos) {
        mstore(pos, leftAlign_t_uint256(cleanup_t_uint256(value)))
    }

    function abi_encode_tuple_packed_t_address_t_stringliteral_a5525611f24e1bc6071cb449f9685b260409906e0e34e953f90e158cb34b71f7_t_address_t_string_memory_ptr_t_uint256_t_uint256__to_t_address_t_string_memory_ptr_t_address_t_string_memory_ptr_t_uint256_t_uint256__nonPadded_inplace_fromStack_reversed(pos , value4, value3, value2, value1, value0) -> end {

        abi_encode_t_address_to_t_address_nonPadded_inplace_fromStack(value0,  pos)
        pos := add(pos, 20)

        pos := abi_encode_t_stringliteral_a5525611f24e1bc6071cb449f9685b260409906e0e34e953f90e158cb34b71f7_to_t_string_memory_ptr_nonPadded_inplace_fromStack( pos)

        abi_encode_t_address_to_t_address_nonPadded_inplace_fromStack(value1,  pos)
        pos := add(pos, 20)

        pos := abi_encode_t_string_memory_ptr_to_t_string_memory_ptr_nonPadded_inplace_fromStack(value2,  pos)

        abi_encode_t_uint256_to_t_uint256_nonPadded_inplace_fromStack(value3,  pos)
        pos := add(pos, 32)

        abi_encode_t_uint256_to_t_uint256_nonPadded_inplace_fromStack(value4,  pos)
        pos := add(pos, 32)

        end := pos
    }

    function abi_encode_tuple_packed_t_string_memory_ptr__to_t_string_memory_ptr__nonPadded_inplace_fromStack_reversed(pos , value0) -> end {

        pos := abi_encode_t_string_memory_ptr_to_t_string_memory_ptr_nonPadded_inplace_fromStack(value0,  pos)

        end := pos
    }

    function store_literal_in_memory_bd7e1badbd5571005a68dc366a4592c503591025ac0a0c34c3af717da0875a2b(memPtr) {

        mstore(add(memPtr, 0), "This address does not exist as a")

        mstore(add(memPtr, 32), " candidate")

    }

    function abi_encode_t_stringliteral_bd7e1badbd5571005a68dc366a4592c503591025ac0a0c34c3af717da0875a2b_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 42)
        store_literal_in_memory_bd7e1badbd5571005a68dc366a4592c503591025ac0a0c34c3af717da0875a2b(pos)
        end := add(pos, 64)
    }

    function abi_encode_tuple_t_stringliteral_bd7e1badbd5571005a68dc366a4592c503591025ac0a0c34c3af717da0875a2b__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_bd7e1badbd5571005a68dc366a4592c503591025ac0a0c34c3af717da0875a2b_to_t_string_memory_ptr_fromStack( tail)

    }

    function store_literal_in_memory_4c3d97f4b70822cc273a56a028cf5e3dd4ccad30ebc47634ae74e2a937da8c39(memPtr) {

        mstore(add(memPtr, 0), "voting has ended")

    }

    function abi_encode_t_stringliteral_4c3d97f4b70822cc273a56a028cf5e3dd4ccad30ebc47634ae74e2a937da8c39_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 16)
        store_literal_in_memory_4c3d97f4b70822cc273a56a028cf5e3dd4ccad30ebc47634ae74e2a937da8c39(pos)
        end := add(pos, 32)
    }

    function abi_encode_tuple_t_stringliteral_4c3d97f4b70822cc273a56a028cf5e3dd4ccad30ebc47634ae74e2a937da8c39__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_4c3d97f4b70822cc273a56a028cf5e3dd4ccad30ebc47634ae74e2a937da8c39_to_t_string_memory_ptr_fromStack( tail)

    }

    function store_literal_in_memory_4a367851a0c771da96dc9bf474920e21eeb850dad602a0bb6473f03632e01258(memPtr) {

        mstore(add(memPtr, 0), "You already voted")

    }

    function abi_encode_t_stringliteral_4a367851a0c771da96dc9bf474920e21eeb850dad602a0bb6473f03632e01258_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 17)
        store_literal_in_memory_4a367851a0c771da96dc9bf474920e21eeb850dad602a0bb6473f03632e01258(pos)
        end := add(pos, 32)
    }

    function abi_encode_tuple_t_stringliteral_4a367851a0c771da96dc9bf474920e21eeb850dad602a0bb6473f03632e01258__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_4a367851a0c771da96dc9bf474920e21eeb850dad602a0bb6473f03632e01258_to_t_string_memory_ptr_fromStack( tail)

    }

    function abi_encode_tuple_t_address_t_bool__to_t_address_t_bool__fromStack_reversed(headStart , value1, value0) -> tail {
        tail := add(headStart, 64)

        abi_encode_t_address_to_t_address_fromStack(value0,  add(headStart, 0))

        abi_encode_t_bool_to_t_bool_fromStack(value1,  add(headStart, 32))

    }

    function panic_error_0x32() {
        mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
        mstore(4, 0x32)
        revert(0, 0x24)
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

    function store_literal_in_memory_9d87b1ff264869b46fdaf9cd74c49271288267a3683a94dfd3e64ce8d18fdac1(memPtr) {

        mstore(add(memPtr, 0), "yet to create a poll")

    }

    function abi_encode_t_stringliteral_9d87b1ff264869b46fdaf9cd74c49271288267a3683a94dfd3e64ce8d18fdac1_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 20)
        store_literal_in_memory_9d87b1ff264869b46fdaf9cd74c49271288267a3683a94dfd3e64ce8d18fdac1(pos)
        end := add(pos, 32)
    }

    function abi_encode_tuple_t_stringliteral_9d87b1ff264869b46fdaf9cd74c49271288267a3683a94dfd3e64ce8d18fdac1__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_9d87b1ff264869b46fdaf9cd74c49271288267a3683a94dfd3e64ce8d18fdac1_to_t_string_memory_ptr_fromStack( tail)

    }

    function panic_error_0x01() {
        mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
        mstore(4, 0x01)
        revert(0, 0x24)
    }

    function store_literal_in_memory_24c71c8fe4ad90b4efca28f2b66d834554e3cdb949355035c00a75fce2c3f72f(memPtr) {

        mstore(add(memPtr, 0), "maximum no of candidate per sess")

        mstore(add(memPtr, 32), "ion registered")

    }

    function abi_encode_t_stringliteral_24c71c8fe4ad90b4efca28f2b66d834554e3cdb949355035c00a75fce2c3f72f_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 46)
        store_literal_in_memory_24c71c8fe4ad90b4efca28f2b66d834554e3cdb949355035c00a75fce2c3f72f(pos)
        end := add(pos, 64)
    }

    function abi_encode_tuple_t_stringliteral_24c71c8fe4ad90b4efca28f2b66d834554e3cdb949355035c00a75fce2c3f72f__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_24c71c8fe4ad90b4efca28f2b66d834554e3cdb949355035c00a75fce2c3f72f_to_t_string_memory_ptr_fromStack( tail)

    }

    function increment_t_uint16(value) -> ret {
        value := cleanup_t_uint16(value)
        if eq(value, 0xffff) { panic_error_0x11() }
        ret := add(value, 1)
    }

    function abi_encode_tuple_t_address__to_t_address__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 32)

        abi_encode_t_address_to_t_address_fromStack(value0,  add(headStart, 0))

    }

    function store_literal_in_memory_5aff5c9b90de18b76ac4b52a073ae2e83cf537f348bf69f219f338118ee37805(memPtr) {

        mstore(add(memPtr, 0), "not the chairman")

    }

    function abi_encode_t_stringliteral_5aff5c9b90de18b76ac4b52a073ae2e83cf537f348bf69f219f338118ee37805_to_t_string_memory_ptr_fromStack(pos) -> end {
        pos := array_storeLengthForEncoding_t_string_memory_ptr_fromStack(pos, 16)
        store_literal_in_memory_5aff5c9b90de18b76ac4b52a073ae2e83cf537f348bf69f219f338118ee37805(pos)
        end := add(pos, 32)
    }

    function abi_encode_tuple_t_stringliteral_5aff5c9b90de18b76ac4b52a073ae2e83cf537f348bf69f219f338118ee37805__to_t_string_memory_ptr__fromStack_reversed(headStart ) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_stringliteral_5aff5c9b90de18b76ac4b52a073ae2e83cf537f348bf69f219f338118ee37805_to_t_string_memory_ptr_fromStack( tail)

    }

}
