--
--  The author disclaims copyright to this source code.  In place of
--  a legal notice, here is a blessing:
--
--    May you do good and not evil.
--    May you find forgiveness for yourself and forgive others.
--    May you share freely, not taking more than you give.
--

with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.Command_Line;
with Ada.Containers;

with Setup;
with Options;
with Command_Line;
with Lime;
with Cherry;
with Rules;
with Symbols;
with Parsers;
with Exceptions;
with Reports;
with Extras;

procedure Cherry_Program is

   procedure Put_Blessing;
   procedure Put_Help;
   procedure Put_Version;
   procedure Put_Statistics (Lemon : in Lime.Lemon_Record);


   procedure Put_Blessing is
      use Ada.Text_IO;
   begin
      Put_Line ("The author disclaims copyright to this source code.  In place of");
      Put_Line ("a legal notice, here is a blessing:");
      New_Line;
      Put_Line ("   May you do good and not evil.");
      Put_Line ("   May you find forgiveness for yourself and forgive others.");
      Put_Line ("   May you share freely, not taking more than you give.");
      New_Line;
   end Put_Blessing;


   procedure Put_Help is
   begin
      Cherry.Dummy;  -- XXX
      Reports.Dummy;
   end Put_Help;


   procedure Put_Version
   is
      use Ada.Text_IO, Setup;
      Version : constant String := Get_Program_Name & " (" & Get_Program_Version & ")";
      Build   : constant String := "Build (" & Get_Build_ISO8601_UTC & ")";
   begin
      Put_Line (Version);
      Put_Line (Build);
      New_Line;
   end Put_Version;


   procedure Put_Statistics (Lemon : in Lime.Lemon_Record)
   is
      procedure Stats_Line (Text  : in String;
                            Value : in Integer);

      procedure Stats_Line (Text  : in String;
                            Value : in Integer)
      is
         use Ada.Text_IO;

         Line : String (1 .. 35) := (others => '.');
      begin
         Line (Line'First .. Text'Last) := Text;
         Line (Text'Last + 1) := ' ';
         Put (Line);
         Put (Integer'Image (Value));
         New_Line;
      end Stats_Line;

      use type Symbols.Symbol_Index;
   begin
      Ada.Text_IO.Put_Line ("Parser statistics:");
      Stats_Line ("terminal symbols", Integer (Lemon.N_Terminal));
      Stats_Line ("non-terminal symbols", Integer (Extras.Symbol_Count - Lemon.N_Terminal));
      Stats_Line ("total symbols", Integer (Extras.Symbol_Count));
      Stats_Line ("rules", Lemon.N_Rule);
      Stats_Line ("states", Lemon.Nx_State);
      Stats_Line ("conflicts", Lemon.N_Conflict);
      Stats_Line ("action table entries", Lemon.N_Action_Tab);
      Stats_Line ("lookahead table entries", Lemon.N_Lookahead_Tab);
      Stats_Line ("total table size (bytes)", Lemon.Table_Size);
   end Put_Statistics;


   use Ada.Command_Line;

   Parse_Success : Boolean;
begin
   Command_Line.Parse (Parse_Success);

   if not Parse_Success then
      Set_Exit_Status (Ada.Command_Line.Failure);
      return;
   end if;

   if Options.Show_Version then
      Put_Version;
      Put_Blessing;
      return;
   end if;

   if Options.Show_Help then
      Put_Help;
      return;
   end if;

   Options.Set_Language;

   declare
      use Ada.Strings.Unbounded;
      use Ada.Text_IO;
      use Lime;
      use Symbols;
      use Rules;

      Lemon : aliased Lime.Lemon_Record;

      Failure : Ada.Command_Line.Exit_Status renames Ada.Command_Line.Failure;

      Dummy_Symbol_Count : Symbol_Index;
   begin
      Lemon := Lime.Clean_Lemon;
      Lemon.Error_Cnt := 0;

      --  Initialize the machine
      Lime.Strsafe_Init;
      Symbols.Symbol_Init;
      Lime.State_Init;

      Lemon.Argv0           := To_Unbounded_String (Options.Program_Name.all);
      Lemon.File_Name       := To_Unbounded_String (Options.Input_File.all);
      Lemon.Basis_Flag      := Options.Basis_Flag;
      Lemon.No_Linenos_Flag := Options.No_Line_Nos;

      Extras.Symbol_Append (Key => "$");

      --  Parse the input file
      Parsers.Parse (Lemon);

      if Lemon.Error_Cnt /= 0 then
         Ada.Command_Line.Set_Exit_Status (Failure);
         return;
      end if;

      if Lemon.N_Rule = 0 then
         Put_Line (Standard_Error, "Empty grammar.");
         Ada.Command_Line.Set_Exit_Status (Failure);
         return;
      end if;

      Extras.Set_Error;

      --  Count and index the symbols of the grammar
      Extras.Symbol_Append (Key => "{default}");

      Symbols.Symbol_Allocate (Ada.Containers.Count_Type (Extras.Symbol_Count));

      Extras.Fill_And_Sort;

      Symbols.Do_Some_Things (Count_In  => Extras.Symbol_Count,
                              Count_Out => Dummy_Symbol_Count);

      --  Assign sequential rule numbers.  Start with 0.  Put rules that have no
      --  reduce action C-code associated with them last, so that the switch()
      --  statement that selects reduction actions will have a smaller jump table.

      Rules.Assing_Sequential_Rule_Numbers
        (Lemon.Rule,
         Lemon.Start_Rule);

--        I := 0;
--        RP := Lemon.Rule;
--        loop
--           exit when RP /= null;
--           if RP.code /= Null_Ptr then
--              RP.iRule := int (I);
--              I := I + 1;
--           else
--              RP.iRule := -1;
--           end if;
--           RP := RP.next;
--        end loop;

--        I := 0;
--        RP := Lemon.Rule;
--        loop
--           exit when RP = null;
--           RP := RP.next;
--        end loop;

--        RP := Lemon.Rule;
--        loop
--           exit when RP = null;
--           if RP.iRule < 0 then
--              RP.iRule := int (I);
--              I := I + 1;
--           end if;
--           RP := RP.next;
--        end loop;

      Lemon.Start_Rule := Lemon.Rule;
      Lemon.Rule       := Rule_Sort (Lemon.Rule);

      --  Generate a reprint of the grammar, if requested on the command line
      if Options.RP_Flag then
         Reports.Reprint (Lemon);
      else
         Reports.Reprint_Of_Grammar
           (Lemon,
            Base_Name     => "XXX",
            Token_Prefix  => "YYY",
            Terminal_Last => 999);
      end if;

      if Options.Statistics then
         Put_Statistics (Lemon);
      end if;

      if Lemon.N_Conflict > 0 then
         Put_Line
           (Standard_Error,
            Integer'Image (Lemon.N_Conflict) & " parsing conflicts.");
      end if;

      if
        Lemon.Error_Cnt  > 0 or
        Lemon.N_Conflict > 0
      then
         Ada.Command_Line.Set_Exit_Status (Failure);
         return;
      end if;
   end;
   Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Success);

exception

   when OCC : Command_Line.Parameter_Error =>
      Exceptions.Put_Message (OCC);


end Cherry_Program;
