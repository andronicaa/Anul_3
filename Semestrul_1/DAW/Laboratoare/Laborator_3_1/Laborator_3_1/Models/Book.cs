using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Laborator_3_1.Models
{
    public class Book
    {
        public int BookId { get; set; }
        [MinLength(5, ErrorMessage = "Title cannot be less than 5"), 
         MaxLength(200, ErrorMessage = "Title cannot be more than 200")]
        public string Title { get; set; }
        public string Author { get; set; }
        public string Summary { get; set; }
        // one-to-many
        public int PublisherId { get; set; }
        public virtual Publisher Publisher { get; set; }
        
        // many-to-many
        public virtual ICollection<Genre> Genres { get; set; }

        // one-to-many - o carte are un singur tip
        
        public int BookTypeId { get; set; }

        [ForeignKey("BookTypeId")]
        public virtual BookType BookType { get; set; }

        [NotMapped]
        public IEnumerable<SelectListItem> PublishersList { get; set; }
        [NotMapped]
        public IEnumerable<SelectListItem> BookTypesList { get; set; }
   

    }
}