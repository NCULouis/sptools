function spexport(tsfile, s, f);
%
%   SPexport write s-paramter to a file in touchstone format
%   spexport( tsfile, s ) wirte the s-parameter matrix 's' to file 'tsfile'. 
%   the s-parameter is required to be nomorlized to 50 Ohm
%
% !!! Each output line only could have maximum 8 columns except the frequency point info one. !!! 
%
if nargin ~= 3
    error('usage: spexport(tsfile, s, f )');
end

[Nport, n, nf]=size(s);


h = fopen(tsfile, 'w');      
if( h==-1) 
    error('cannot open file for write'); 
end

fprintf(h, '! s-parmerter generated by Matlab\r\n');
fprintf(h, '#        HZ        S              RI          R       50\r\n');

for i=1:nf
   fprintf(h, '%9.8e ', f(i) );
   abc=f(i);
	for j=1:Nport
      for k=1:Nport
         m=(j-1)*Nport+k;
         if mod(m-1, 4)~=0 
         elseif m==1 
         else fprintf(h, '\r\n'); fprintf(h, '                ');
         end
         fprintf(h, '% 13.12e ', [real(s(j,k,i)); imag(s(j,k,i))]);
      end
   end
   fprintf(h, '\r\n'); 
end

fclose(h);
return;