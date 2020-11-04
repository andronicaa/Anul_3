using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Laborator_3.Models
{
    public class Publisher
    {
        [Key]
        public int PublisherId { get; set; }
        public String Name { get; set; }
        public virtual ICollection<Book> Books { get; set; }
        [Required]
        public virtual ContactInfo ContactInfo { get; set; }
    }
}