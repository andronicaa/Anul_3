using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Planner.Models.ViewModels
{
    public class ShoppingListViewModel
    {
        public int ShoppingListId { get; set; }
        public string Titlu { get; set; }
        public IEnumerable<Product> ShoppingProducts { get; set; }
    }
}