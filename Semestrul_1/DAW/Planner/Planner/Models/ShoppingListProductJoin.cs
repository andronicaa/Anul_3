using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Planner.Models
{
    public class ShoppingListProductJoin
    {
        public int ShoppingListProductId { get; set; }
        public int ShoppingListRef { get; set; }
        public virtual ShoppingList ShoppingList { get; set; }
        public int ProductId { get; set; }
        public virtual Product Product { get; set; }
    }
}