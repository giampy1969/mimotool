function m = soldi(iT,ii,T,t)

% m = soldi(iT,ii,T,t)
% m=montante al tempo t , iT=tasso di interesse 
% ii=tasso di inflazione ,T=periodo di capitalizzazione 
% Giampiero Campa 4-3-94

m=(1+iT).^floor(t./T).*(1+iT.*(t./T-floor(t./T))).*(1+ii).^(-t);

