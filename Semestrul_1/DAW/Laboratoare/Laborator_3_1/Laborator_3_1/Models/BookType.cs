using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Laborator_3_1.Models
{
    public class BookType
    {
        public int BookTypeId { get; set; }
        
        public string Name { get; set; }
        // many to one
        public virtual ICollection<Book> Books { get; set; }
    }
}