using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Laborator_3.Models
{
    public class Genre
    {
        [Key]
        public int GenreId { get; set; }
        public String Name { get; set; }
        public virtual ICollection<Book> books { get; set; }
    }
}