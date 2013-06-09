using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using Hello_Word_MVC;
using Hello_Word_MVC.Controllers;

namespace Hello_Word_MVC.Tests
{
	[TestFixture ()]
	public class HomeControllerTest
	{
		[Test ()]
		public void Index ()
		{
			// Arrange
			HomeController controller = new HomeController ();

			// Act
			ViewResult result = controller.Index () as ViewResult;

			// Assert
			Assert.AreEqual ("Welcome to ASP.NET MVC on Mono!", result.ViewData ["Message"]);
		}
	}
}
