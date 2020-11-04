using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Laborator_3.Models
{
    public class Book
    {
        public int BookId { get; set; }
        public String Title { get; set; }
        public String Author { get; set; }
        public DateTime DateCreation { get; set; }
        public String Summary { get; set; }
    }
}