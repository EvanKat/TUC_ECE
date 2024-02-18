#include <math.h>
#include <stdio.h>
#include "pilib.h"

const int N = -100; 
const int n2 = 2;
int a, b, c;

int power2(int i)	{
return pow(i,n2);
}

double divid(int i, int j)	{
return i / j;
}

int foo(int x, int n, int k)	{
double j, i, l;
j = power2(x); 
i = j + n; 
l = divid(i,k); 
writeString("The powered number is:"); 
writeInt(j); 
writeString("\n"); 
writeString("The added powered number is:"); 
writeInt(j); 
writeString("\n"); 
writeString("The divided added powered number is:"); 
writeReal(l); 
writeString("\n"); 
return l;
}
 int main()	{
double x;
writeString("\nGive 1st number to power it to 2: "); 
a = readInt(); 
writeString("\n"); 
writeString("\nGive 2nd number to add it to the previous: "); 
b = readReal(); 
writeString("\n"); 
writeString("\nGive 3nd number to divede it with the previous: "); 
c = readReal(); 
x = foo(a,b,c) + N; 
writeReal(x); 
writeString("\n");
}

