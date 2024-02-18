#include <math.h>
#include <stdio.h>
#include "pilib.h"

int year = 0;

int askdate()	{
int k;
writeString("Give your birthday year\t :"); 
k = readInt(); 
return k;
}

int checkinput(int x)	{
x = readInt(); 
while (x != 0 && x != 1) 
{
writeString("Its very simple, \"1\" for yes and \"0\" for no\n"); 
x = readInt();
} 
return x;
}

int askinfo()	{
int y[2], l; 
int result, cur;
writeString("\n"); 
writeString("Please give some info for yourself. Nothing to fear :)\n"); 
writeString("Type \"1\" for yes and \"0\" for no\n"); 
writeString("\n"); 
writeString("Are you smoking: "); 
checkinput(y[0]); 
writeString("\n"); 
writeString("Are you drinking: "); 
checkinput(y[1]); 
writeString("\n"); 
writeString("Are you gona accept this project? :"); 
checkinput(l); 
return l;
}
int main()	{
int years = askdate(), num; 
int z;
z = askinfo(); 
years = 2021 - years; 
if (z == 1) 
	{
writeString("You are fine and you are almost "); 
writeInt(years);
} 
else 
	{
writeString("Your are "); 
writeInt(years); 
writeString(" years old and you have to accept this project. Then everything is gona be ok!"); 
writeString("\n");
}
}

