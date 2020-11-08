using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Laborator_3_1.Models
{
    public class Genre
    {
        public int GenreId { get; set; }
        public string Name { get; set; }
        // many-to-many
        public virtual ICollection<Book> books { get; set; }
    }
}