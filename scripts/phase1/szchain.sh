s=szchain && \
d=gameofzoneshub-1a && \
p=szchain_gameofzoneshub-1a
 
rly l u $s && rly l u $d || : && rly tst req $s || : && rly q bal $s -j && rly q bal $d -j && rly tx clnts $p -d &> a; wait && rly tx conn $p -d &> b; wait && rly tx chan $p -d &> c; wait && rly pth s $p && dc=$(rly pth s $p -j | jq -r '.chains.dst."client-id"') && sc=$(rly pth s $p -j | jq -r '.chains.src."client-id"') && while :; do rly tx raw uc $d $s $dc && rly tx raw uc $s $d $sc && sleep 60 ; done
