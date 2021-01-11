using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Planner.Models
{
    public class ShoppingList
    {
        public int ShoppingListId { get; set; }

        [Required(ErrorMessage = "Camp obligatoriu")]
        [StringLength(15, ErrorMessage = "Titlul trebuie sa fie de lungime cuprinsa intre 4 si 15.", MinimumLength = 4)]
        public string Titlu { get; set; }

        

        // many-to-many relation
        public virtual ICollection<Product> Products { get; set; }

        [NotMapped]
        public IEnumerable<SelectListItem> ProductsList { get; set; }
    }
}