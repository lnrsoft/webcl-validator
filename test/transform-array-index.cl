// RUN: cat %s | grep -v DRIVER-MAY-REJECT | %opencl-validator
// RUN: %webcl-validator %s -- -x cl -include %include/_kernel.h 2>&1 | grep -v CHECK | %FileCheck %s

__kernel void transform_array_index(
    __global int *array)
{
    const int i = get_global_id(0);

    int pair[2] = { 0, 0 };
    // CHECK: pair[wcl_idx(i + 0, 2UL)] = 0;
    pair[i + 0] = 0;
    // CHECK: pair[wcl_idx(i + 1, 2UL)] = 1;
    (i + 1)[pair] = 1; // DRIVER-MAY-REJECT

    // CHECK: array[wcl_global_int_idx(NULL, array, i)] = pair[wcl_idx(i + 0, 2UL)]
    array[i] = pair[i + 0]
    // CHECK: + pair[wcl_idx(i + 1, 2UL)]
        + (i + 1)[pair] // DRIVER-MAY-REJECT
        ;
}