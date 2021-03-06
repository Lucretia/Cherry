--
--  The author disclaims copyright to this source code.  In place of
--  a legal notice, here is a blessing:
--
--    May you do good and not evil.
--    May you find forgiveness for yourself and forgive others.
--    May you share freely, not taking more than you give.
--

package body Symbols is


--   subtype Cursor is Symbol_Lists.Cursor;


   function "<" (Left, Right : in Symbol_Name) return Boolean;

   function From_Key (Key : Key_Type) return Unbounded_String;


   function "<" (Left, Right : in Symbol_Name) return Boolean
   is
      Length_Min   : constant Natural := Natural'Min (Length (Left),
                                                      Length (Right));

      String_Left  : constant String := To_String (Left);
      String_Right : constant String := To_String (Right);
      S_Left       : constant String :=
        String_Left  (String_Left'First  .. String_Left'First  + Length_Min);
      S_Right      : constant String :=
        String_Right (String_Right'First .. String_Right'First + Length_Min);
   begin
      return (S_Left < S_Right);
   end "<";


   function From_Key (Key : Key_Type) return Unbounded_String
   is
   begin
      return Null_Unbounded_String;
   end From_Key;






   function To_Key (Item : in String) return Key_Type
   is
   begin
      return To_Unbounded_String (Item);
   end To_Key;


   function From_Key (Key : in Key_Type) return String
   is
   begin
      return To_String (Key);
   end From_Key;






--   procedure Sort is
--      new Ada.Containers.Generic_Array_Sort
--     (Index_Type   => Symbol_Index,
--      Element_Type => Symbol_Access,
--      Array_Type   => Symbol_Access_Array);

--      "<"          => Symbol_Compare);
--   procedure Do_Sort (Container : in out Symbol_Access_Array) is
--   begin
--      null;  --  Sort (Container);
--   end Do_Sort;


   procedure Do_Some_Things (Count_In  : in     Symbol_Index;
                             Count_Out :    out Symbol_Index)
   is
   begin
      null;
            --  The following

      --  XXX Section XXX

--        for Idx in 0 .. Lemon.N_Symbol - 1 loop
--           Lemon.Symbols.all (Idx).all.Index := Idx;
--           I := Idx;  --  C for loop hack dehacked
--        end loop;
--        I := I + 1;   --  C for loop hack dehacked

--        while Lemon.Symbols.all (I - 1).all.Kind = Symbols.Multi_Terminal loop
--           I := I - 1;
--        end loop;

      --  XXX Section End XXX

--        pragma Assert (Lemon.Symbols.all (I - 1).Name = New_String ("{default}"));
--        Lemon.N_Symbol := I - 1;

--        I := 1;
--        loop
--           declare
--              Text  : constant String    := Value (Lemon.Symbols.all (I).Name);
--              First : constant Character := Text (Text'First);
--           begin
--              exit when Auxiliary.Is_Upper (First);
--              I := I + 1;
--           end;
--        end loop;

--        Lemon.N_Terminal := I;

   end Do_Some_Things;





--     function "<" (Left, Right : in Symbol_Access)
--                  return Boolean
--     is
--        function Value_Of (Item : in Symbol_Access) return Integer;

--        function Value_Of (Item : in Symbol_Access) return Integer is
--           use Interfaces.C.Strings;
--           Kind : constant Symbol_Kind := Item.Kind;
--           Name : constant String      := Value (Item.Name);
--           Char : constant Character   := Name (Name'First);
--        begin
--           if Kind = MULTITERMINAL then return 3;
--           elsif Char > 'Z'        then return 2;
--           else                         return 1;
--           end if;
--        end Value_Of;

--        I_Left  : constant Integer := Value_Of (Left);
--        I_Right : constant Integer := Value_Of (Right);
--     begin
--        if I_Left = I_Right then
--           return (Left.Index - Right.Index) > 0;
--        else
--           return (I_Left - I_Right) > 0;
--        end if;
--     end "<";
   function "<" (Left  : in Symbol_Record;
                 Right : in Symbol_Record)
                return Boolean
   is
      function Value_Of (Item : in Symbol_Record) return Integer;

      function Value_Of (Item : in Symbol_Record) return Integer
      is
         Kind : constant Symbol_Kind := Item.Kind;
         Name : constant String      := To_String (Item.Name);
         Char : constant Character   := Name (Name'First);
      begin
         if Kind = Multi_Terminal then return 3;
         elsif Char > 'Z'         then return 2;
         else                          return 1;
         end if;
      end Value_Of;

      I_Left  : constant Integer := Value_Of (Left);
      I_Right : constant Integer := Value_Of (Right);
   begin
      if I_Left = I_Right then
         return (Left.Index - Right.Index) > 0;
      else
         return (I_Left - I_Right) > 0;
      end if;
   end "<";



   procedure Symbol_Init is
   begin
      null;
   end Symbol_Init;


--     procedure Symbol_Insert (Symbol : in Symbol_Record;
--                              Name   : in Symbol_Name)
--     is
--        Position : Symbol_Maps.Cursor;
--        Inserted : Boolean;
--     begin
--        Symbol_Maps.Insert
--          (Container => Extra.Symbol_Map,
--           Key       => Name, --  To_Unbounded_String (Name),
--           New_Item  => Symbol,
--           Position  => Position,
--           Inserted  => Inserted);
--     end Symbol_Insert;



--     function Symbol_Nth (Index : in Symbol_Index)
--                         return Symbol_Cursor
--     is
--        use Symbol_Maps;
--        Element : Symbol_Name;
--        Position : Symbol_Maps.Cursor := First (Extra.Symbol_Map);
--        Count    : Symbol_Index := 0;
--     begin
--        for Count in 0 .. Index loop
--           Position := Next (Position);
--        end loop;
--        return null;  --   To_Cursor (Position);
--  --      Element := Symbol_Maps.Element (Index); --  Extra.Symbol_Map);
--  --      return Element;
--     end Symbol_Nth;




--     function Symbol_Array_Of return Symbol_Access_Array_Access;
--     --  Return an array of pointers to all data in the table.
--     --  The array is obtained from malloc.  Return NULL if memory allocation
--     --  problems, or if the array is empty.
   procedure Symbol_Allocate (Count : in Ada.Containers.Count_Type) is
   begin
      --  Symbol_Lists (Ada.Containers.Doubly_Linked_Lists) does not nave
      --  operation for setting length or capacity

      --  Symbol_Maps (Ada.Containers.Ordered_Maps does not nave
      --  operation for setting length or capacity

      null;
      --  Symbol_Lists.Set_Length (Extra.Symbol_Vector, Count);
      --  Symbol_Maps.
--        Extras.Symbol_Map := Symbols_Maps.Empty_Map;
--        for Index in
--          Symbol_Vectors.First (Extra.Symbol_Vector) ..
--          Symbol_Vectors.Last  (Extra.Symbol_Vector)
--        loop
--           Symbol_Maps.Replace_Element (Extras.Symbol_Map,
--        end loop;
   end Symbol_Allocate;


   function Create (Name : in String)
                   return Symbol_Access
   is
   begin
      return null;
   end Create;

--     is--     function Lime_Symbol_New
--       (Name : in Interfaces.C.Strings.chars_ptr)
--       return Symbol_Access
--     is
--        use Interfaces.C.Strings;
--        Cursor : Symbol_Cursor;
--        Symbol : Symbol_Access;
--     begin
--        Cursor := Symbol_New (Value (Name));
--        return Symbol;
--     end Lime_Symbol_New;


   function Find (Key : in String)
                 return Symbol_Access
   is
   begin
      return null;
   end Find;

--     function Lime_Symbol_Find
--       (Name : in Interfaces.C.Strings.chars_ptr)
--       return Symbol_Access
--     is
--        use Interfaces.C.Strings;
--        Cursor : Symbol_Cursor;
--        Symbol : Symbol_Access;
--     begin
--        Cursor := Symbol_Find (Value (Name));
--        return Symbol;
--     end Lime_Symbol_Find;



end Symbols;

