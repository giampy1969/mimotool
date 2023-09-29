function ea_2v(index)

global stack


disp('--------------------------------------');
switch index
   case 1,disp('-------Desired Eigenvalues------------');
   case 2,disp('-------Desired Eigenvectors-----------');
   case 3,disp('-------Achievable Eigenvectors--------');
   case 4,disp('-------Closed-Loop  Eigenvalues-------');
          if stack.temp.tipo==1
             disp('-----> with REAL STATE FEEDBACK <-----');
          end;  
   case 5,disp('-------Closed-Loop  Eigenvectors------');
          if stack.temp.tipo==1
             disp('-----> with REAL STATE FEEDBACK <-----');
          end;  
end;
disp('--------------------------------------');
switch index
   case 1,stack.temp.a_val
   case 2,stack.temp.a_vet
   case 3,stack.temp.ach_vet
   case 4,stack.temp.cla_val
   case 5,stack.temp.cla_vet
end
sprintf('\n');

