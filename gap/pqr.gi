msg.allGroupsPQR := function(n)
  local fac, p, q, r, coll, G1, G2, G3, G4, G5, G6, s, i;
    s := [];
    fac := Factors(n);
    if not Length(fac) = 3 then
      Error("Argument must be a product of three distinct primes"); fi;
    r := fac[1];
    q := fac[2];
    p := fac[3];
    G1 := [ [r, q, p] ]; #(C_r \ltimes C_q) \times C_p

    Add(s, msg.groupFromData(G1));

    if not (p - 1) mod q = 0 and not (p - 1) mod r = 0 and not (q - 1) mod r = 0 then
      return s; fi;

    G2 := function(p, q, r) #(C_r \ltimes C_q) \times C_p
      local s, data;
        s := Int((Z(q))^((q-1)/r));
        data := [ [r, q, p], [2, 1, [2, s]] ];
      return msg.groupFromData(data);
    end;

    if (q - 1) mod r = 0 then
      Add(s, G2(p, q, r));fi;

    G3 := function(p, q, r) #(C_r \ltimes C_p) \times C_q
      local t, data;
        t := Int((Z(p))^((p-1)/r));
        data := [ [r, q, p], [3, 1, [3, t]] ];
      return msg.groupFromData(data);
    end;
    if (p - 1) mod r = 0 then
      Add(s, G3(p, q, r));fi;

    G4 := function(p, q, r, k) #C_r \ltimes (C_q \times C_p)
      local data, s, t;
        s := (Z(q))^((q-1)/r);
        t := (Z(p))^((p-1)/r);
        data := [ [r, q, p], [2, 1, [2, Int(s)]], [3, 1, [3, Int(t^k)]] ];
      return msg.groupFromData(data);
    end;
    ##
    if (q - 1) mod r = 0 and (p - 1) mod r = 0 then
      for i in [1..(r - 1)] do
        Add(s, G4(p, q, r, i));
      od;
    fi;
    ##
    G5 := function(p, q, r) #C_r \times (C_q \ltimes C_p)
      local data, o;
        o := Int((Z(p))^((p-1)/q));
        data := [ [r, q, p], [3, 2, [3, o]] ];
      return msg.groupFromData(data);
    end;
    if (p - 1) mod q = 0 then
      Add(s, G5(p, q, r));fi;

    G6 := function(p, q, r) #(C_r \times C_q) \ltimes C_p
      local data, o, t;
        o := Int((Z(p))^((p-1)/q));
        t := Int((Z(p))^((p-1)/r));
        data := [ [r, q, p], [3, 1, [3, t]], [3, 2, [3, o]] ];
      return msg.groupFromData(data);
    end;
    if (p - 1) mod r = 0 and (p - 1) mod q = 0 then
      Add(s, G6(p, q, r));fi;
  return s;
end;
##############################################
msg.NumberGroupsPQR := function(n)
  local fac, p, q, r, w;
    fac := Factors(n);
    if not Length(fac) = 3 then
      Error("Argument must be a product of two distinct primes"); fi;
    r := fac[1];
    q := fac[2];
    p := fac[3];
    w := 1 + msg.deltaDivisibility((q-1), r) + msg.deltaDivisibility((p - 1), r) + (r - 1) * msg.deltaDivisibility((q - 1), r) * msg.deltaDivisibility((p - 1), r) + msg.deltaDivisibility((p - 1), q) + msg.deltaDivisibility((p - 1), r) * msg.deltaDivisibility((p - 1), q);
  return w;
end;
##############################################
msg.GroupPQR := function(n, i)
  local fac, all, p, q, r, a, b, k, G;
    fac := Factors(n);
    if not Length(fac) = 3 then
      Error("Argument must be a product of three distinct primes"); fi;
    r := fac[1];
    q := fac[2];
    p := fac[3];
    all := [ [ [r, q, p] ] ];
    a := Z(p);
    b := Z(q);

    if (q - 1) mod r = 0 then
      Add(all, [ [r, q, p], [2, 1, [2, Int(b^((q-1)/r))]] ]);fi;

    if (p - 1) mod r = 0 then
      Add(all, [ [r, q, p], [3, 1, [3, Int(a^((p-1)/r))]] ]);fi;

    if (q - 1) mod r = 0 and (p - 1) mod r = 0 then
      for k in [1..(r - 1)] do
        Add(all, [ [r, q, p], [2, 1, [2, Int(b^((q-1)/r))]], [3, 1, [3, Int(a^(k*(p-1)/r))]] ]);
      od;
    fi;

    if (p - 1) mod q = 0 then
      Add(all, [ [r, q, p], [3, 2, [3, Int(a^((p-1)/q))]] ]);fi;

    if (p - 1) mod r = 0 and (p - 1) mod q = 0 then
      Add(all, [ [r, q, p], [3, 1, [3, Int(a^((p-1)/r))]], [3, 2, [3, Int(a^((p-1)/q))]] ]);fi;

    if i < (msg.NumberGroupsPQR(n) + 1) then
      G := msg.groupFromData(all[i]);
      return G;
    else Error(("There are "), msg.NumberGroupsPQR(n), (" isomorphism types of groups of order "), n, ("."));
    fi;
end;