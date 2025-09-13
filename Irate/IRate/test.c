#include <stdint.h>

#define N 256

uint32_t fib(uint32_t n) {
    if (n < 2) return n;
    return fib(n-1) + fib(n-2);
}

void fun(int A[N][N], int B[N][N], int C[N][N]) {
    for (int i=0;i<N;i++)
        for (int j=0;j<N;j++) {
            int sum=0;
            for (int k=0;k<N;k++)
                sum += A[i][k] * B[k][j];
            C[i][j]=sum;
        }
}

void filter(int *x, int *y, int len) {
    for (int i=1;i<len-1;i++)
        y[i]=(x[i-1]+x[i]+x[i+1])/3;
}

int main() {
    static int A[N][N],B[N][N],C[N][N];
    static int X[1024],Y[1024];
    fun(A,B,C);
    filter(X,Y,1024);
    return fib(15);
}
