﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Laborator_3_1.Models.MyValidation;

namespace Laborator_3_1.Models
{
    public class Book
    {
        public int BookId { get; set; }

        
        public string Title { get; set; }

        
        public string Author { get; set; }

        
        public string Summary { get; set; }
        


        [PrimeNumberValidation]
        public int NoOfPages { get; set; }

        // one-to-many
        // o editura publica mai multe carti(lista de Books in clasa Publisher)
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