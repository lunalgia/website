-- Don't try to read the following code; it is merely a demo for how you should _not_ write code.
-- Just try running the `main` function in GHCi after loading the file.



{-# OPTIONS_GHC -Wno-missing-signatures #-}
{- HLINT ignore "Redundant $" -}

-- GOLFED CODE BELOW!

import Data.List(intercalate,intersperse,transpose);import Control.Monad((>=>),void);import Data.Bool(bool);data C=X|O|E deriving Eq;instance Show C where show X=" X ";show O=" O ";show E="   "
o=intersperse;a=intercalate;u=pure;r=u Nothing;f=maybe;v=putStrLn;c n=bool(putStr "1 to 9:">>readLn>>=c)(u((n-1)`div`3,(n-1)`mod`3))$0<n&&n<10;l=[0..2];p t=f r(\h->do{putStr$"("++show t++"):";(x,y)<-readLn>>=c;bool(u.Just$[[if(i,j)==(x,y)then t else h!!i!!j|j<-l]|i<-l])(p t.Just$h)(h!!x!!y/=E)});b=f r(\h->v(a"\n───┼───┼───\n"$map(a"│".map show)h)>>u(Just h));e=f r(\h->let d=[h!!i!!i|i<-l]:[h!!i!!(2-i)|i<-l]:h++transpose h;w x n y=bool y(b(Just h)>>v n>>r)x in w([X,X,X]`elem`d)"X won".w([O,O,O]`elem`d)"O won".w(E`notElem`concat h)"Draw".u$Just h);g=(>=>e).foldl1(>=>).o e.o(q O)$replicate 5(q X)where q t=b>=>p t;
main=(void.g).Just$replicate 3$replicate 3 E
