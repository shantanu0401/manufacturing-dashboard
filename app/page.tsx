"use client"

import { useState } from "react"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Progress } from "@/components/ui/progress"
import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from "@/components/ui/accordion"
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, LineChart, Line } from "recharts"
import { TrendingUp, AlertTriangle, CheckCircle, Clock, Settings, Database, BarChart3 } from "lucide-react"

// Sample data for charts
const oeeData = [
  { month: "Jan", availability: 85, performance: 78, quality: 92, oee: 61 },
  { month: "Feb", availability: 88, performance: 82, quality: 94, oee: 68 },
  { month: "Mar", availability: 82, performance: 75, quality: 89, oee: 55 },
  { month: "Apr", availability: 90, performance: 85, quality: 96, oee: 73 },
  { month: "May", availability: 87, performance: 80, quality: 93, oee: 65 },
  { month: "Jun", availability: 91, performance: 88, quality: 97, oee: 78 },
]

const abnormalityData = [
  { category: "Minor Flaws", identified: 45, closed: 38 },
  { category: "Basic Conditions", identified: 32, closed: 28 },
  { category: "Inaccessible Places", identified: 18, closed: 15 },
  { category: "Contamination Sources", identified: 25, closed: 22 },
  { category: "Quality Defects", identified: 12, closed: 10 },
  { category: "Unnecessary Items", identified: 35, closed: 33 },
  { category: "Unsafe Places", identified: 8, closed: 7 },
]

const costData = [
  { category: "Labor", variable: 2.5, fixed: 1.8, total: 4.3 },
  { category: "Power", variable: 1.2, fixed: 0.8, total: 2.0 },
  { category: "Fuel", variable: 0.9, fixed: 0.3, total: 1.2 },
  { category: "Maintenance", variable: 0.7, fixed: 1.1, total: 1.8 },
]

const COLORS = ["#0088FE", "#00C49F", "#FFBB28", "#FF8042", "#8884D8"]

export default function ManufacturingDashboard() {
  const [activeTab, setActiveTab] = useState("back-to-basics")

  return (
    <div className="min-h-screen bg-gray-50 p-4">
      <div className="max-w-7xl mx-auto space-y-6">
        {/* Header */}
        <div className="bg-white rounded-lg shadow-sm p-6">
          <h1 className="text-3xl font-bold text-gray-900">Manufacturing Analytics Dashboard</h1>
          <p className="text-gray-600 mt-2">Total Productive Maintenance (TPM) Performance Metrics</p>
        </div>

        {/* Main Dashboard */}
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
          {/* Main Content */}
          <div className="lg:col-span-3">
            <Tabs value={activeTab} onValueChange={setActiveTab} className="space-y-4">
              <TabsList className="grid w-full grid-cols-4 lg:grid-cols-8">
                <TabsTrigger value="back-to-basics" className="text-xs">
                  5S/TPM
                </TabsTrigger>
                <TabsTrigger value="productivity" className="text-xs">
                  Productivity
                </TabsTrigger>
                <TabsTrigger value="quality" className="text-xs">
                  Quality
                </TabsTrigger>
                <TabsTrigger value="cost" className="text-xs">
                  Cost
                </TabsTrigger>
                <TabsTrigger value="delivery" className="text-xs">
                  Delivery
                </TabsTrigger>
                <TabsTrigger value="safety" className="text-xs">
                  Safety
                </TabsTrigger>
                <TabsTrigger value="environment" className="text-xs">
                  Environment
                </TabsTrigger>
                <TabsTrigger value="morale" className="text-xs">
                  Morale
                </TabsTrigger>
              </TabsList>

              {/* Tab 1: Back-To-Basics */}
              <TabsContent value="back-to-basics" className="space-y-6">
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                  {/* 5S Score Card */}
                  <Card className="md:col-span-2">
                    <CardHeader>
                      <CardTitle className="flex items-center gap-2">
                        <BarChart3 className="h-5 w-5" />
                        5S Score Card
                      </CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-4">
                        <div className="flex justify-between items-center">
                          <span className="text-sm font-medium">Overall 5S Score</span>
                          <Badge variant="secondary">78/100</Badge>
                        </div>
                        <Progress value={78} className="h-2" />

                        <div className="grid grid-cols-2 gap-4 mt-4">
                          <div className="space-y-2">
                            <div className="flex justify-between text-sm">
                              <span>Sort (Seiri)</span>
                              <span>85%</span>
                            </div>
                            <Progress value={85} className="h-1" />
                          </div>
                          <div className="space-y-2">
                            <div className="flex justify-between text-sm">
                              <span>Set in Order (Seiton)</span>
                              <span>72%</span>
                            </div>
                            <Progress value={72} className="h-1" />
                          </div>
                          <div className="space-y-2">
                            <div className="flex justify-between text-sm">
                              <span>Shine (Seiso)</span>
                              <span>80%</span>
                            </div>
                            <Progress value={80} className="h-1" />
                          </div>
                          <div className="space-y-2">
                            <div className="flex justify-between text-sm">
                              <span>Standardize (Seiketsu)</span>
                              <span>75%</span>
                            </div>
                            <Progress value={75} className="h-1" />
                          </div>
                        </div>
                      </div>
                    </CardContent>
                  </Card>

                  {/* Abnormality Status */}
                  <Card>
                    <CardHeader>
                      <CardTitle className="flex items-center gap-2">
                        <AlertTriangle className="h-5 w-5" />
                        Abnormality Status
                      </CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-3">
                        <div className="flex justify-between items-center">
                          <span className="text-sm">Total Identified</span>
                          <Badge variant="destructive">175</Badge>
                        </div>
                        <div className="flex justify-between items-center">
                          <span className="text-sm">Closed</span>
                          <Badge variant="secondary">153</Badge>
                        </div>
                        <div className="flex justify-between items-center">
                          <span className="text-sm">Open</span>
                          <Badge variant="outline">22</Badge>
                        </div>
                        <div className="pt-2 border-t">
                          <div className="text-xs text-gray-600">Spares Required</div>
                          <div className="text-sm font-medium">$12,500</div>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                </div>

                {/* Abnormality Details Chart */}
                <Card>
                  <CardHeader>
                    <CardTitle>Category-wise Abnormality Status</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <ResponsiveContainer width="100%" height={300}>
                      <BarChart data={abnormalityData}>
                        <CartesianGrid strokeDasharray="3 3" />
                        <XAxis dataKey="category" angle={-45} textAnchor="end" height={80} />
                        <YAxis />
                        <Tooltip />
                        <Bar dataKey="identified" fill="#ef4444" name="Identified" />
                        <Bar dataKey="closed" fill="#22c55e" name="Closed" />
                      </BarChart>
                    </ResponsiveContainer>
                  </CardContent>
                </Card>

                {/* Kaizens and RCA */}
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <Card>
                    <CardHeader>
                      <CardTitle>Kaizens</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-3">
                        <div className="flex justify-between">
                          <span className="text-sm">Implemented</span>
                          <Badge>45</Badge>
                        </div>
                        <div className="flex justify-between">
                          <span className="text-sm">Replicated</span>
                          <Badge variant="secondary">32</Badge>
                        </div>
                        <div className="grid grid-cols-2 gap-2 text-xs">
                          <div>P: 8</div>
                          <div>Q: 12</div>
                          <div>C: 15</div>
                          <div>D: 6</div>
                          <div>S: 3</div>
                          <div>E: 1</div>
                        </div>
                      </div>
                    </CardContent>
                  </Card>

                  <Card>
                    <CardHeader>
                      <CardTitle>Root Cause Analysis</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-3">
                        <div className="flex justify-between">
                          <span className="text-sm">Pending</span>
                          <Badge variant="destructive">8</Badge>
                        </div>
                        <div className="flex justify-between">
                          <span className="text-sm">Closed</span>
                          <Badge variant="secondary">27</Badge>
                        </div>
                        <div className="flex justify-between">
                          <span className="text-sm">Repeated Failures</span>
                          <Badge variant="outline">5</Badge>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                </div>
              </TabsContent>

              {/* Tab 2: Productivity */}
              <TabsContent value="productivity" className="space-y-6">
                {/* OEE Overview */}
                <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                  <Card>
                    <CardHeader className="pb-2">
                      <CardTitle className="text-sm">Overall OEE</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="text-2xl font-bold">65.8%</div>
                      <div className="flex items-center text-sm text-green-600">
                        <TrendingUp className="h-4 w-4 mr-1" />
                        +2.3%
                      </div>
                    </CardContent>
                  </Card>
                  <Card>
                    <CardHeader className="pb-2">
                      <CardTitle className="text-sm">Availability</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="text-2xl font-bold">87.2%</div>
                      <div className="text-xs text-gray-600">Target: 90%</div>
                    </CardContent>
                  </Card>
                  <Card>
                    <CardHeader className="pb-2">
                      <CardTitle className="text-sm">Performance</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="text-2xl font-bold">81.4%</div>
                      <div className="text-xs text-gray-600">Target: 85%</div>
                    </CardContent>
                  </Card>
                  <Card>
                    <CardHeader className="pb-2">
                      <CardTitle className="text-sm">Quality</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="text-2xl font-bold">92.8%</div>
                      <div className="text-xs text-gray-600">Target: 95%</div>
                    </CardContent>
                  </Card>
                </div>

                {/* OEE Trend Chart */}
                <Card>
                  <CardHeader>
                    <CardTitle>OEE Trend Analysis</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <ResponsiveContainer width="100%" height={300}>
                      <LineChart data={oeeData}>
                        <CartesianGrid strokeDasharray="3 3" />
                        <XAxis dataKey="month" />
                        <YAxis />
                        <Tooltip />
                        <Line type="monotone" dataKey="availability" stroke="#8884d8" name="Availability" />
                        <Line type="monotone" dataKey="performance" stroke="#82ca9d" name="Performance" />
                        <Line type="monotone" dataKey="quality" stroke="#ffc658" name="Quality" />
                        <Line type="monotone" dataKey="oee" stroke="#ff7300" strokeWidth={3} name="OEE" />
                      </LineChart>
                    </ResponsiveContainer>
                  </CardContent>
                </Card>

                {/* Loss Analysis */}
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <Card>
                    <CardHeader>
                      <CardTitle>MTBF/MTTR Analysis</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-4">
                        <div>
                          <div className="flex justify-between items-center">
                            <span className="text-sm">MTBF (Hours)</span>
                            <span className="font-bold">156.2</span>
                          </div>
                          <Progress value={78} className="h-2 mt-1" />
                        </div>
                        <div>
                          <div className="flex justify-between items-center">
                            <span className="text-sm">MTTR (Hours)</span>
                            <span className="font-bold">2.8</span>
                          </div>
                          <Progress value={65} className="h-2 mt-1" />
                        </div>
                      </div>
                    </CardContent>
                  </Card>

                  <Card>
                    <CardHeader>
                      <CardTitle>Downtime Segmentation</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-2">
                        <div className="flex justify-between text-sm">
                          <span>Mechanical</span>
                          <span>45%</span>
                        </div>
                        <div className="flex justify-between text-sm">
                          <span>Electrical</span>
                          <span>25%</span>
                        </div>
                        <div className="flex justify-between text-sm">
                          <span>Instrumentation</span>
                          <span>20%</span>
                        </div>
                        <div className="flex justify-between text-sm">
                          <span>Setting</span>
                          <span>10%</span>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                </div>
              </TabsContent>

              {/* Tab 3: Quality */}
              <TabsContent value="quality" className="space-y-6">
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  <Card>
                    <CardHeader>
                      <CardTitle className="text-sm">Market Complaints</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="text-2xl font-bold">12</div>
                      <div className="text-xs text-red-600">+3 from last month</div>
                    </CardContent>
                  </Card>
                  <Card>
                    <CardHeader>
                      <CardTitle className="text-sm">First Pass Yield</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="text-2xl font-bold">94.2%</div>
                      <div className="text-xs text-green-600">Target: 95%</div>
                    </CardContent>
                  </Card>
                  <Card>
                    <CardHeader>
                      <CardTitle className="text-sm">Cost of Poor Quality</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="text-2xl font-bold">$45K</div>
                      <div className="text-xs text-gray-600">This month</div>
                    </CardContent>
                  </Card>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <Card>
                    <CardHeader>
                      <CardTitle>Cp/Cpk Analysis</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-3">
                        <div className="flex justify-between">
                          <span className="text-sm">Process A</span>
                          <div className="text-right">
                            <div className="text-sm">Cp: 1.45</div>
                            <div className="text-sm">Cpk: 1.32</div>
                          </div>
                        </div>
                        <div className="flex justify-between">
                          <span className="text-sm">Process B</span>
                          <div className="text-right">
                            <div className="text-sm">Cp: 1.28</div>
                            <div className="text-sm">Cpk: 1.15</div>
                          </div>
                        </div>
                      </div>
                    </CardContent>
                  </Card>

                  <Card>
                    <CardHeader>
                      <CardTitle>Material Yield</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-3">
                        <div className="flex justify-between">
                          <span className="text-sm">Raw Material</span>
                          <Badge variant="secondary">98.5%</Badge>
                        </div>
                        <div className="flex justify-between">
                          <span className="text-sm">Packaging Material</span>
                          <Badge variant="secondary">97.2%</Badge>
                        </div>
                        <div className="flex justify-between">
                          <span className="text-sm">BOM Variance</span>
                          <Badge variant="destructive">-2.3%</Badge>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                </div>
              </TabsContent>

              {/* Tab 4: Cost */}
              <TabsContent value="cost" className="space-y-6">
                <Card>
                  <CardHeader>
                    <CardTitle>Cost Analysis per Unit</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <ResponsiveContainer width="100%" height={300}>
                      <BarChart data={costData}>
                        <CartesianGrid strokeDasharray="3 3" />
                        <XAxis dataKey="category" />
                        <YAxis />
                        <Tooltip />
                        <Bar dataKey="variable" fill="#8884d8" name="Variable Cost" />
                        <Bar dataKey="fixed" fill="#82ca9d" name="Fixed Cost" />
                      </BarChart>
                    </ResponsiveContainer>
                  </CardContent>
                </Card>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <Card>
                    <CardHeader>
                      <CardTitle>Budget Variance</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-3">
                        <div className="flex justify-between">
                          <span className="text-sm">YTD Variance</span>
                          <Badge variant="destructive">+5.2%</Badge>
                        </div>
                        <div className="flex justify-between">
                          <span className="text-sm">MTD Variance</span>
                          <Badge variant="secondary">-1.8%</Badge>
                        </div>
                      </div>
                    </CardContent>
                  </Card>

                  <Card>
                    <CardHeader>
                      <CardTitle>Resource Balancing</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-2">
                        <div className="flex justify-between text-sm">
                          <span>Material Efficiency</span>
                          <span>96.8%</span>
                        </div>
                        <div className="flex justify-between text-sm">
                          <span>Energy Efficiency</span>
                          <span>94.2%</span>
                        </div>
                        <div className="flex justify-between text-sm">
                          <span>Water Efficiency</span>
                          <span>98.1%</span>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                </div>
              </TabsContent>

              {/* Tab 5: Delivery */}
              <TabsContent value="delivery" className="space-y-6">
                <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                  <Card>
                    <CardHeader className="pb-2">
                      <CardTitle className="text-sm">Production Plan vs Actual</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="text-2xl font-bold">98.5%</div>
                      <div className="text-xs text-green-600">On target</div>
                    </CardContent>
                  </Card>
                  <Card>
                    <CardHeader className="pb-2">
                      <CardTitle className="text-sm">Dispatch Plan vs Actual</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="text-2xl font-bold">96.2%</div>
                      <div className="text-xs text-yellow-600">Below target</div>
                    </CardContent>
                  </Card>
                  <Card>
                    <CardHeader className="pb-2">
                      <CardTitle className="text-sm">Stock Availability</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="text-2xl font-bold">94.8%</div>
                      <div className="text-xs text-gray-600">Target: 95%</div>
                    </CardContent>
                  </Card>
                  <Card>
                    <CardHeader className="pb-2">
                      <CardTitle className="text-sm">Freight Cost/Unit</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="text-2xl font-bold">$2.45</div>
                      <div className="text-xs text-red-600">+$0.15</div>
                    </CardContent>
                  </Card>
                </div>
              </TabsContent>

              {/* Tab 6: Safety */}
              <TabsContent value="safety" className="space-y-6">
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  <Card>
                    <CardHeader>
                      <CardTitle className="text-sm">Near Miss Incidents</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="text-2xl font-bold">8</div>
                      <div className="text-xs text-yellow-600">This month</div>
                    </CardContent>
                  </Card>
                  <Card>
                    <CardHeader>
                      <CardTitle className="text-sm">PPE Compliance</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="text-2xl font-bold">97.5%</div>
                      <div className="text-xs text-green-600">Target: 100%</div>
                    </CardContent>
                  </Card>
                  <Card>
                    <CardHeader>
                      <CardTitle className="text-sm">Lost Time Injuries</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="text-2xl font-bold">0</div>
                      <div className="text-xs text-green-600">Zero incidents</div>
                    </CardContent>
                  </Card>
                </div>
              </TabsContent>

              {/* Tab 7: Environment */}
              <TabsContent value="environment" className="space-y-6">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <Card>
                    <CardHeader>
                      <CardTitle>Carbon Emissions</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-3">
                        <div className="flex justify-between">
                          <span className="text-sm">Scope 1 (Direct)</span>
                          <span className="font-bold">125 tCO2e</span>
                        </div>
                        <div className="flex justify-between">
                          <span className="text-sm">Scope 2 (Indirect)</span>
                          <span className="font-bold">89 tCO2e</span>
                        </div>
                      </div>
                    </CardContent>
                  </Card>

                  <Card>
                    <CardHeader>
                      <CardTitle>Waste Generation</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-3">
                        <div className="flex justify-between">
                          <span className="text-sm">Hazardous Waste</span>
                          <span className="font-bold">2.5 tons</span>
                        </div>
                        <div className="flex justify-between">
                          <span className="text-sm">Recycled</span>
                          <span className="font-bold">85%</span>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                </div>
              </TabsContent>

              {/* Tab 8: Morale */}
              <TabsContent value="morale" className="space-y-6">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <Card>
                    <CardHeader>
                      <CardTitle>Individual Performance</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-2">
                        <div className="flex justify-between text-sm">
                          <span>Avg Abnormalities/Person</span>
                          <span>3.2</span>
                        </div>
                        <div className="flex justify-between text-sm">
                          <span>Avg Kaizens/Person</span>
                          <span>1.8</span>
                        </div>
                        <div className="flex justify-between text-sm">
                          <span>Training Hours/Person</span>
                          <span>12.5</span>
                        </div>
                      </div>
                    </CardContent>
                  </Card>

                  <Card>
                    <CardHeader>
                      <CardTitle>Skill Matrix Coverage</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="text-2xl font-bold">78%</div>
                      <div className="text-xs text-gray-600">Multi-skilled operators</div>
                    </CardContent>
                  </Card>
                </div>
              </TabsContent>
            </Tabs>
          </div>

          {/* Sidebar */}
          <div className="space-y-4">
            <Accordion type="single" collapsible className="w-full">
              <AccordionItem value="master-data">
                <AccordionTrigger className="flex items-center gap-2">
                  <Database className="h-4 w-4" />
                  Master Data Library
                </AccordionTrigger>
                <AccordionContent>
                  <div className="space-y-2 text-sm">
                    <div className="p-2 hover:bg-gray-100 rounded cursor-pointer">Bill of Materials</div>
                    <div className="p-2 hover:bg-gray-100 rounded cursor-pointer">Capacity Working</div>
                    <div className="p-2 hover:bg-gray-100 rounded cursor-pointer">SKU Mapping</div>
                    <div className="p-2 hover:bg-gray-100 rounded cursor-pointer">Skill Matrix</div>
                    <div className="p-2 hover:bg-gray-100 rounded cursor-pointer">Machine Mapping</div>
                    <div className="p-2 hover:bg-gray-100 rounded cursor-pointer">Spare Parts</div>
                  </div>
                </AccordionContent>
              </AccordionItem>

              <AccordionItem value="standards">
                <AccordionTrigger className="flex items-center gap-2">
                  <Settings className="h-4 w-4" />
                  Standards
                </AccordionTrigger>
                <AccordionContent>
                  <div className="space-y-2 text-sm">
                    <div className="p-2 hover:bg-gray-100 rounded cursor-pointer">Standard Manpower</div>
                    <div className="p-2 hover:bg-gray-100 rounded cursor-pointer">Standard Power Usage</div>
                    <div className="p-2 hover:bg-gray-100 rounded cursor-pointer">Standard Fuel Usage</div>
                    <div className="p-2 hover:bg-gray-100 rounded cursor-pointer">Machine SOPs</div>
                    <div className="p-2 hover:bg-gray-100 rounded cursor-pointer">Operator Mapping</div>
                  </div>
                </AccordionContent>
              </AccordionItem>

              <AccordionItem value="simulation">
                <AccordionTrigger className="flex items-center gap-2">
                  <BarChart3 className="h-4 w-4" />
                  Simulation
                </AccordionTrigger>
                <AccordionContent>
                  <div className="space-y-2 text-sm">
                    <div className="p-2 hover:bg-gray-100 rounded cursor-pointer">OEE Forecasting</div>
                    <div className="p-2 hover:bg-gray-100 rounded cursor-pointer">Cost Optimization</div>
                    <div className="p-2 hover:bg-gray-100 rounded cursor-pointer">Quality Simulation</div>
                    <div className="p-2 hover:bg-gray-100 rounded cursor-pointer">What-if Analysis</div>
                    <div className="p-2 hover:bg-gray-100 rounded cursor-pointer">Benchmarking</div>
                  </div>
                </AccordionContent>
              </AccordionItem>
            </Accordion>

            {/* Implementation Roadmap */}
            <Card>
              <CardHeader>
                <CardTitle className="text-sm">Implementation Roadmap</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-3">
                  <div className="flex items-center gap-2">
                    <CheckCircle className="h-4 w-4 text-green-500" />
                    <span className="text-xs">Phase 1: Foundation (3-6M)</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <Clock className="h-4 w-4 text-yellow-500" />
                    <span className="text-xs">Phase 2: Advanced (6-12M)</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <Clock className="h-4 w-4 text-gray-400" />
                    <span className="text-xs">Phase 3: Optimization (12M+)</span>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </div>
  )
}
