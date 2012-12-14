using System;
using System.Collections.Generic;
using System.IO;
using System.Xml;

namespace XmlDiff
{
	internal class XmlConverter : BaseReader
	{
		private readonly string xml;
		private readonly Root root;
		private readonly Stack<Node> queue;
		private Node parent;
		private Node lastNode;
		private int lastDepth;

		internal XmlConverter (string xml)
			: base()
		{
			this.xml = xml;
			this.root = new Root();
			this.queue = new Stack<Node>();
		}
		
		internal List<Node> Convert()
		{
			Initialize ();
			
			using (StringReader sr = new StringReader(this.xml))
			{
				using (base.xmlReader = XmlReader.Create(sr))
				{					
					List<Node> nodeCollection = new List<Node>();
					
		            while (!base.xmlReader.EOF && base.xmlReader.Read())
		            {
		                if (base.IsStartElement())
		                {
							SetParent ();

							Node currentNode = CreateNode ();							

							ReadAttributes(currentNode);
							SetNodeText (currentNode);
							
							nodeCollection.Add(currentNode);
						}
						else if (base.IsEndElement ())
						{
							lastDepth = base.xmlReader.Depth;
							
							parent = queue.Pop ().Parent;
						}
					}
					
					return nodeCollection;
				}
			}
		}

		private void Initialize ()
		{
			this.queue.Clear ();
			this.queue.Push (root);

			this.parent = null;
			this.lastNode = null;
			this.lastDepth = 0;
		}

		private void SetParent ()
		{
			if (base.xmlReader.Depth == 0)
			{
				this.parent = this.root;
			} 
			else if (lastDepth < base.xmlReader.Depth)
			{
				this.queue.Push (this.lastNode);
				this.parent = this.lastNode;
			}
		}

		private Node CreateNode ()
		{
			Node currentNode = new Node (this.parent);
			this.lastNode = currentNode;
			this.lastDepth = currentNode.Depth = base.xmlReader.Depth;
			currentNode.Name = base.xmlReader.Name;

			return currentNode;
		}

		private void ReadAttributes (Node node)
		{
			if (base.xmlReader.HasAttributes)
			{
				node.AttributeCollection = new Dictionary<string, string>();
				
				for(int i = 0; i < base.xmlReader.AttributeCount; i++)
				{
					base.xmlReader.MoveToAttribute(i);
					
					node.AttributeCollection.Add(base.xmlReader.Name, base.xmlReader.GetAttribute(i));
				}
				
				base.xmlReader.MoveToElement();
			}
		}

		private void SetNodeText (Node currentNode)
		{
			if (base.xmlReader.HasValue) 
			{
				currentNode.Text = base.xmlReader.Value;
			}
		}
	}
}

