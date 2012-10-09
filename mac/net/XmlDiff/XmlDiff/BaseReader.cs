using System.Xml;

namespace XmlDiff
{
    internal abstract class BaseReader
    {
        protected XmlReader xmlReader;
		
		protected BaseReader()
		{
		}

        protected virtual bool IsStartElement()
        {
            return (this.xmlReader.NodeType == XmlNodeType.Element);
        }

		protected virtual bool IsEndElement()
		{
			return (this.xmlReader.NodeType == XmlNodeType.EndElement || this.xmlReader.IsEmptyElement);
		}

        protected virtual bool IsEndElement(string nodeName)
        {
            return ((this.xmlReader.NodeType == XmlNodeType.EndElement || this.xmlReader.IsEmptyElement) &&
                this.xmlReader.Name == nodeName);
        }
    }
}
