--
--  The author disclaims copyright to this source code.  In place of
--  a legal notice, here is a blessing:
--
--    May you do good and not evil.
--    May you find forgiveness for yourself and forgive others.
--    May you share freely, not taking more than you give.
--

with Ada.Strings;

package Auxiliary.Text is

   procedure Trim
     (Item  : in     String;
      First : in out Natural;
      Last  : in out Natural;
      Side  : in     Ada.Strings.Trim_End);

end Auxiliary.Text;
