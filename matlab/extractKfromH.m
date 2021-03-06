% Copyright (c) <2014>, <vicrucann@gmail.com>
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
% 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%
% 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

% H is a cell of matrices {h1,h2,...,hn} from views {1,2,...,n}, n>=3
function K = extractKfromH(H) 
nviews = size(H,3);
V = zeros(2*nviews, 6);
for i = 1 : nviews
    h = reshape(H{i},3,3);
    v12 = composevij(1,2,h);
    v11 = composevij(1,1,h);
    v22 = composevij(2,2,h);
    V(i*2-1,:) = v12';
    V(i*2,:) = (v11-v22)';
end
[~, ~, d] = svd(V'*V);
b = d(:,end);
v0 = (b(2)*b(4)-b(1)*b(5)) / (b(1)*b(3)-b(2)^2);
lambda = b(6) - (b(4)^2 + v0*(b(2)*b(4)-b(1)*b(5))) / b(1);
alpha = sqrt(lambda/b(1));
beta = sqrt(lambda*b(1) / (b(1)*b(3)-b(2)^2));
gamma = -b(2)*alpha^2*beta/lambda;
u0 = gamma*v0/beta - b(4)*alpha^2/lambda;
K = [...
    alpha gamma u0; ...
    0 beta v0; ...
    0 0 1];
% B = [b(1) b(2) b(4);...
%     b(2) b(3) b(5);...
% b(4) b(5) b(6)];
% K = inv(chol(B));
% K = K/K(3,3);

function vij = composevij(i,j,H)
vij = [H(1,i)*H(1,j), H(1,i)*H(2,j)+H(2,i)*H(1,j), H(2,i)*H(2,j), ...
    H(3,i)*H(1,j)+H(1,i)*H(3,j), H(3,i)*H(2,j)+H(2,i)*H(3,j), H(3,i)*H(3,j)]';
