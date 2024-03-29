﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace Planner.Models
{
    public class ShoppingListProductJoin
    {
        [Key]
        public int Id { get; set; }
        public int ShoppingListId { get; set; }
       
        public ShoppingList ShoppingList { get; set; }
        
        
        public int ProductId { get; set; }
       
        public Product Product { get; set; }
    }
}