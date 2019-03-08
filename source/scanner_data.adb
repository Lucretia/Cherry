--
--  The author disclaims copyright to this source code.  In place of
--  a legal notice, here is a blessing:
--
--    May you do good and not evil.
--    May you find forgiveness for yourself and forgive others.
--    May you share freely, not taking more than you give.
--

package body Scanner_Data is


   function Current_Char (Scanner : in Scanner_Record)
                         return Character
   is
   begin
      return Scanner.Item (Scanner.First);
   end Current_Char;


   function Current_Line (Scanner : in Scanner_Record)
                         return String
   is
   begin
      return Scanner.Item (Scanner.First .. Scanner.Last);
   end Current_Line;


end Scanner_Data;
