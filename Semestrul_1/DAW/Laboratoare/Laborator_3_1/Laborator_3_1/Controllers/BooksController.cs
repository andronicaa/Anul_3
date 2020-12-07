using Laborator_3_1.DataAccessLayer;
using Laborator_3_1.Models;
using System;
using System.CodeDom;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Laborator_3_1.Controllers
{
    
    [RoutePrefix("books")]
    public class BooksController : Controller
    {   // pentru a se accesa in mod concret baza de date din controller
        // vom introduce un obiect privat din clasa context
        private MyDbCtx ctx = new MyDbCtx();
        // GET: Books
        public ActionResult Index()
        {
            // salveaza toate cartile din baza de date intr-o lista
            List<Book> books = ctx.Books.ToList();
            return View(books);

        }

        [Route("cauta/{id:regex(^[0-9]+$)}")]
        public ActionResult Cauta(int id)
        {
            Book book = ctx.Books.Find(id);
            return View(book);
        }


        [Route("detalii/{id?}")]
        public ActionResult Detalii(int? id)
        {
            if (id.HasValue)
            {
                // cautam cartea cu id-ul dat in baza de date
                Book book = ctx.Books.Find(id);
                if (book != null)
                {
                    return View(book);

                }
                return HttpNotFound("Cartea cu id-ul dat nu exista");
            }
            return HttpNotFound("Missing book id parameter!");
        }

        [Route("new")]
        public ActionResult New()
        {
            Book book = new Book();
            book.BookTypesList = GetAllBookTypes();
            book.Genres = new List<Genre>();
            return View(book);
        }

        // se adauga acest atribut pentru ca metoda sa fie accesata
        // doar prin metoda post, nu direct din browser

        [HttpPost]
        public ActionResult Create(Book b)
        {

            try
            {
                b.BookTypesList = GetAllBookTypes();
                if (ModelState.IsValid)
                {
                    b.Publisher = ctx.Publishers.FirstOrDefault(p => p.PublisherId.Equals(1));
                    ctx.Books.Add(b);
                    ctx.SaveChanges();
                    return RedirectToAction("Index", "Books");
                }
                return RedirectToAction("New", "Books");
            }
            catch (Exception e)
            {
                return RedirectToAction("New", "Books");
            }

        }

        [NonAction] // specificam faptul ca aceasta matoda nu este o actiune
        public IEnumerable<SelectListItem> GetAllBookTypes()
        {
            // trebuie sa extragem toate cartile din baza de date
            // general o lista goala
            var selectList = new List<SelectListItem>();
            foreach(var type in ctx.BookTypes.ToList())
            {
                // adaugam fiecare tip din baza de date in lista declarata
                selectList.Add(new SelectListItem
                {
                    Value = type.BookTypeId.ToString(),
                    Text = type.Name
                });

                // returnam lista
                
            }
            return selectList;
        }
        [Route("edit/{?id}")]
        public ActionResult Edit(int? id)
        {
            if (id.HasValue)
            {
                Book book = ctx.Books.Find(id);
                if (book == null)
                {
                    return HttpNotFound("Couldn't find the book with id " + id.ToString());
                }
                book.BookTypesList = GetAllBookTypes();
                return View(book);
            }
            return HttpNotFound("Missing book id parameter!");
        }

        [HttpPut]
        public ActionResult Update(Book bookRequest)
        {
            try
            {
                bookRequest.BookTypesList = GetAllBookTypes();
                if (ModelState.IsValid)
                {
                    Book book = ctx.Books
                   .Include("Publisher")
                    .SingleOrDefault(b => b.BookId.Equals(bookRequest.BookId));
                    if (TryUpdateModel(book))
                    {
                        book.Title = bookRequest.Title;
                        book.Author = bookRequest.Author;
                        book.Summary = bookRequest.Summary;
                        book.NoOfPages = bookRequest.NoOfPages;
                        ctx.SaveChanges();
                    }
                    return RedirectToAction($"Detalii/{bookRequest.BookId}", "Books");
                }
                return View("Edit", bookRequest);
            }
            catch (Exception e)
            {
                return View(bookRequest);
            }
        }

        [HttpDelete]
        public ActionResult Delete(int id)
        {
            Book book = ctx.Books.Find(id);
            if (book != null)
            {
                ctx.Books.Remove(book);
                ctx.SaveChanges();
                return RedirectToAction("Index", "Books");
            }
            return HttpNotFound("Couldn't find the book with id " + id.ToString());


        }
    }
}