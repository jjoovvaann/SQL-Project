-- References
ALTER TABLE [dbo].[Account]  WITH CHECK ADD  CONSTRAINT [FK_Account_Currency] FOREIGN KEY([CurrencyId])
REFERENCES [dbo].[Currency] ([id])
GO
ALTER TABLE [dbo].[Account] CHECK CONSTRAINT [FK_Account_Currency]
GO


ALTER TABLE [dbo].[Account]  WITH CHECK ADD  CONSTRAINT [FK_Account_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
GO
ALTER TABLE [dbo].[Account] CHECK CONSTRAINT [FK_Account_Customer]
GO
ALTER TABLE [dbo].[Account]  WITH CHECK ADD  CONSTRAINT [FK_Account_Employee] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([ID])
GO
ALTER TABLE [dbo].[Account] CHECK CONSTRAINT [FK_Account_Employee]
GO
ALTER TABLE [dbo].[AccountDetails]  WITH CHECK ADD  CONSTRAINT [FK_AccountDetails_Account] FOREIGN KEY([AccountId])
REFERENCES [dbo].[Account] ([Id])
GO
ALTER TABLE [dbo].[AccountDetails] CHECK CONSTRAINT [FK_AccountDetails_Account]
GO
ALTER TABLE [dbo].[AccountDetails]  WITH CHECK ADD  CONSTRAINT [FK_AccountDetails_Employee] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([ID])
GO
ALTER TABLE [dbo].[AccountDetails] CHECK CONSTRAINT [FK_AccountDetails_Employee]
GO
ALTER TABLE [dbo].[AccountDetails]  WITH CHECK ADD  CONSTRAINT [FK_AccountDetails_Location] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[AccountDetails] CHECK CONSTRAINT [FK_AccountDetails_Location]
GO
ALTER TABLE [dbo].[Location]  WITH CHECK ADD  CONSTRAINT [FK_Location_LocationType] FOREIGN KEY([LocationTypeId])
REFERENCES [dbo].[LocationType] ([Id])
GO
ALTER TABLE [dbo].[Location] CHECK CONSTRAINT [FK_Location_LocationType]
GO