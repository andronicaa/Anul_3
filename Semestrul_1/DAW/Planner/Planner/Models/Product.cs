using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Planner.Models
{
    public class Product
    {
        public int ProductId { get; set; }
        public string Denumire { get; set; }
        public string Cantitate { get; set; }
        public string Descriere { get; set; }

        // many-to-many relation
        public ICollection<ShoppingList> ShoppingLists { get; set; }
    }
}