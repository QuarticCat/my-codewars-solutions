int find_even_index(const int* values, int length) {
    int lsum = 0, rsum = 0;
    for (int i = 0; i < length; ++i) rsum += values[i];
    for (int i = 0; i < length; ++i) {
        rsum -= values[i];
        if (lsum == rsum) return i;
        lsum += values[i];
    }
    return -1;
}
