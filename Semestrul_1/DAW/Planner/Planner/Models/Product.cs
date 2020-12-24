using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Planner.Models
{
    public class Product
    {
        public int ProductId { get; set; }
        
        [Required]
        [StringLength(10, ErrorMessage = "Titlul trebuie sa fie de lungime cuprinsa intre 3 si 10.", MinimumLength = 3)]
        public string Denumire { get; set; }

        [Required]
        public string Cantitate { get; set; }

        [Required]
        [StringLength(30, ErrorMessage = "Descrierea trebuie sa fie de lungime cuprinsa intre 5 si 30.", MinimumLength = 5)]
        public string Descriere { get; set; }

        // acest cand nu este obligatoriu
        public Necesitate Necesitate { get; set; }


        // many-to-many relation
        public ICollection<ShoppingList> ShoppingLists { get; set; }
    }
    public enum Necesitate
    {
        Mica, 
        Urgent
    }
}