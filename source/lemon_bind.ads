--
--  The author disclaims copyright to this source code.  In place of
--  a legal notice, here is a blessing:
--
--    May you do good and not evil.
--    May you find forgiveness for yourself and forgive others.
--    May you share freely, not taking more than you give.
--

with Interfaces.C.Strings;

with Lime;
with Rules;

package Lemon_Bind is

   procedure Error_Message
     (File_Name : Interfaces.C.Strings.chars_ptr;
      I : Integer;
      S : String);
   
   procedure Configlist_Init;

   function Configlist_Add_Basis
     (RP : in Rules.Rule_Access;
      I  : in Integer) return Lime.Config_Access;

   procedure Set_Add (Config : in Interfaces.C.Strings.Chars_Ptr; --  Lime.Config_Access;
                      I      : in Integer);

   procedure Get_State (Lem : in out Lime.Lemon_Record);
   
private

   pragma Import (C, Error_Message,        "lemon_error_message");
   pragma Import (C, Configlist_Init,      "lemon_configlist_init");
   pragma Import (C, Configlist_Add_Basis, "lemon_configlist_add_basis");
   pragma Import (C, Set_Add,              "lemon_set_add");
   pragma Import (C, Get_State,            "lemon_get_state");

end Lemon_Bind;
