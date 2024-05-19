# Model-Indentification-using-PCA

![image](https://github.com/ansh63766/Model-Indentification-using-PCA/assets/113677013/52fa1e64-23e1-4871-9b52-ae974a1b7919)

Above is the steam distribution network for a chemical plant. A sample of 
measurements corresponding to a subset of the 28 streams have been generated and 
stored in file steamdata.mat. The true values of the flows are stored in variable Ftrue 
and the corresponding measured values in variable Fmeas. The subset of flow variables 
that are measured is given in variable Fmindx. The variance of noise in all measured 
flows are identical.

Using the true values of flows, we determined the number of constraints and the true constraint matrix relating the measured subset of flow variables by eig function.

Eigenvalues that I got:
![image](https://github.com/ansh63766/Model-Indentification-using-PCA/assets/113677013/8eb03fde-fcaa-480c-bb33-e74c958c0966)

So, by crude method we can clearly see that there are 6 no of constraints or we can say 6 dependent variables.
So, taking the eigenvectors corresponding to these 6 eigenvalues and transposing it we will get our constraint matrix that will be of size 6*23

I have find all the possible condition numbers and stored them in table in sorted way, so all the combinations giving low condition numbers are good guesses for the dependent variable while the ones with very high are the worst case. 
So, taking the first set as the dependent variable - (5     7    16    17    19    23)
The rest of the variables as independent
![image](https://github.com/ansh63766/Model-Indentification-using-PCA/assets/113677013/cecceb09-0df1-4e32-97b6-e70fcea9750d)

Following regression matrix obtained for Ftrue:
![image](https://github.com/ansh63766/Model-Indentification-using-PCA/assets/113677013/0e09dbd5-0e14-448e-a585-621c6b9828d8)

Eigenvalues obtained for Fmeas:
![image](https://github.com/ansh63766/Model-Indentification-using-PCA/assets/113677013/fec276d4-16be-4355-a5d7-1a2e3f7d8b60)

Can clearly say that there are 6 no of constraints and after using hypothesis testing also we can say that there are 6 no of constraints.
![image](https://github.com/ansh63766/Model-Indentification-using-PCA/assets/113677013/8e98076d-1f15-47a4-b9b2-103a16f18dec)

So, at no of constraints = 6 we got our first not rejected so total number of constraints is 6.

Estimated error Variance:
![image](https://github.com/ansh63766/Model-Indentification-using-PCA/assets/113677013/1e53bec3-603f-4819-bb3d-1fe23e7b00c8)

Estimated Regression Matrix:
![image](https://github.com/ansh63766/Model-Indentification-using-PCA/assets/113677013/197957fd-5a87-4eb7-bbe1-06abe8222f58)

Maximum abs diff:
![image](https://github.com/ansh63766/Model-Indentification-using-PCA/assets/113677013/43902c18-5f08-4642-b30a-3c6a65c2a81d)
