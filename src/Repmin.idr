module Repmin

-- The repmin problem, based on http://www.springerlink.com/content/g74174vvl1861605/

map : (a -> b) -> Lazy a -> Lazy b
map f l = f l

trace : (a -> Lazy b -> (c, b)) -> a -> c
trace f x = fst (loop f x)
  where
    loop : (a -> Lazy b -> (c, b)) -> a -> Lazy (c, b)
    loop f x = f x (map snd (loop f x))

data Tree a = Leaf a | Branch (Tree a) (Tree a)

copy : Tree Int -> Lazy Int -> (Tree (Lazy Int), Int)
copy (Leaf x) l = (Leaf l, x)
copy (Branch x y) l = let (tl, ml) = copy x l
                          (tr, mr) = copy y l in
                          (Branch tl tr, min ml mr)

repmin : Tree Int -> Tree (Lazy Int)
repmin t = trace copy t

print : Tree (Lazy Int) -> String
print (Leaf x) = "L " ++ (show x)
print (Branch x y) = "(B " ++ print x ++ " " ++ print y ++ ")"

test : String
test = print . repmin $ Branch (Branch (Leaf 0) (Leaf 2)) (Leaf 1)
